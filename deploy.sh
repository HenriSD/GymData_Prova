#!/usr/bin/env bash
# =============================================================================
# deploy.sh — GymData: Build → Tag → ECR Push → Deploy
# Cobre o pipeline de CI/CD exigido na avaliação de Infraestrutura (TA012)
# Uso: ./deploy.sh [--skip-ecr] [--down]
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()   { echo -e "${GREEN}[OK]${NC}    $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

SKIP_ECR=false
TEARDOWN=false
for arg in "$@"; do
  [[ "$arg" == "--skip-ecr" ]] && SKIP_ECR=true
  [[ "$arg" == "--down"     ]] && TEARDOWN=true
done

# =============================================================================
# TEARDOWN
# =============================================================================
if $TEARDOWN; then
  warn "Destruindo toda a infraestrutura e volumes..."
  docker compose down -v --remove-orphans
  ok "Infraestrutura removida."
  exit 0
fi

# =============================================================================
# PRÉ-REQUISITOS
# =============================================================================
log "Verificando pré-requisitos..."
command -v docker &>/dev/null || err "Docker não encontrado."
[[ -f .env ]] || err "Arquivo .env não encontrado. Copie .env.example para .env."
set -a; source .env; set +a
ok "Pré-requisitos verificados."

# =============================================================================
# FASE 1: BUILD
# =============================================================================
IMAGE_NAME="${ECR_REGISTRY:-local}/${ECR_REPOSITORY:-gymdata}"
FULL_TAG="${IMAGE_NAME}:${IMAGE_TAG:-latest}"
DATE_TAG="${IMAGE_NAME}:$(date +%Y%m%d-%H%M%S)"

log "Fase 1: Build da imagem (Multi-stage)..."
docker build \
  --target runtime \
  --tag "$FULL_TAG" \
  --tag "$DATE_TAG" \
  --file docker/node-web/Dockerfile \
  . || err "Falha no build."

ok "Imagem construída: $FULL_TAG"

# =============================================================================
# FASE 2 & 3: ECR PUSH
# =============================================================================
if ! $SKIP_ECR; then
  log "Fase 2/3: Autenticando no ECR e fazendo push..."
  aws ecr get-login-password --region "${AWS_REGION:-us-east-1}" \
    | docker login --username AWS --password-stdin "${ECR_REGISTRY}" \
    || err "Falha na autenticação com o ECR."

  aws ecr describe-repositories \
    --repository-names "${ECR_REPOSITORY}" \
    --region "${AWS_REGION:-us-east-1}" &>/dev/null \
  || aws ecr create-repository \
      --repository-name "${ECR_REPOSITORY}" \
      --region "${AWS_REGION:-us-east-1}"

  docker push "$FULL_TAG" || err "Falha no push."
  docker push "$DATE_TAG" || err "Falha no push."
  ok "Imagem enviada para o ECR."
else
  warn "Push para ECR ignorado (--skip-ecr)."
fi

# =============================================================================
# FASE 4: DEPLOY
# =============================================================================
log "Fase 4: Subindo infraestrutura (Node + PostgreSQL + Redis + Nginx)..."
docker compose down --remove-orphans 2>/dev/null || true
docker compose up -d --build

log "Aguardando serviços ficarem healthy..."
sleep 15
docker compose ps

# =============================================================================
# EVIDÊNCIAS
# =============================================================================
echo ""
echo "============================================================"
echo " EVIDÊNCIAS DE FUNCIONAMENTO"
echo "============================================================"

log "Inspecionando rede (DNS interno):"
docker network inspect gymdata_app-network 2>/dev/null || \
  docker network inspect gymdata-app-network 2>/dev/null || \
  docker network ls | grep gymdata

log "Volumes nomeados (persistência):"
docker volume ls | grep gymdata

log "DNS interno — ping de app para db:"
docker exec gymdata_app ping -c 2 db 2>/dev/null \
  || warn "Ping falhou — verifique se o container está healthy."

log "DNS interno — ping de app para cache:"
docker exec gymdata_app ping -c 2 cache 2>/dev/null \
  || warn "Ping falhou — verifique se o container está healthy."

echo ""
ok "Deploy concluído!"
ok "API disponível em: http://localhost:8080"
ok "Swagger:           http://localhost:8080/api-docs"
ok "Para logs:         docker compose logs -f"
ok "Para destruir:     ./deploy.sh --down"
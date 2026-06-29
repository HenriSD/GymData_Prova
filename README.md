# 🏋️ GymData — Sistema de Gerenciamento de Academia

API REST para gerenciamento de academia: alunos, planos, matrículas e treinos.

---

## 1. Identificação do Projeto

| Campo | Valor |
|---|---|
| **Título** | GymData — Sistema de Gerenciamento de Academia |
| **Descrição** | API REST em Node.js/Express com banco PostgreSQL, cache Redis e proxy Nginx, containerizada seguindo padrões de produção DevOps. |
| **Caminho Infra** | Opção A — Docker / Orquestração Local (Compose) |

---

## 2. Containers

| Container | Imagem | Função |
|---|---|---|
| `gymdata_db` | postgres:17-alpine | Banco de dados PostgreSQL |
| `gymdata_cache` | redis:7-alpine | Cache Redis |
| `gymdata_app` | node:24-alpine (build local) | API Node.js/Express (privado) |
| `gymdata_nginx` | nginx:alpine | Proxy reverso (porta 8080) |

> Arquitetura: `Host → Nginx:8080 → app:3000 → db:5432`
> O Node.js **não tem porta exposta ao host**. O Redis e o PostgreSQL também não.

---

## 3. Pré-requisitos

```bash
docker --version        # Docker Desktop >= 24.x
docker compose version  # >= 2.x
```

WSL2 com Ubuntu habilitado no Docker Desktop:
`Settings → Resources → WSL Integration → Ubuntu ✓`

---

## 4. Como executar o projeto

### Passo 1 — Clonar o repositório
```bash
git clone <url-do-repositorio>
cd gymdata
```

### Passo 2 — Configurar variáveis de ambiente
```bash
cp .env.example .env
```

### Passo 3 — Instalar dependências (gera o package-lock.json)
```bash
npm install
```

### Passo 4 — Subir os containers
```bash
docker compose up --build
```

### Passo 5 — Executar as migrations
```bash
docker compose run --rm cli migrate
```

A API estará disponível em: **http://localhost:8080**

---

## 5. Como executar as migrations

```bash
# Criar tabelas (sem apagar dados)
docker compose run --rm cli migrate

# Recriar todas as tabelas do zero
docker compose run --rm cli migrate:fresh
```

> O container `cli` sobe, executa o comando e encerra — container efêmero conforme padrão DevOps.

---

## 6. Como realizar login e usar o token JWT

### Criar o primeiro usuário
```bash
curl -X POST http://localhost:8080/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"Admin","email":"admin@gymdata.com","senha":"123456"}'
```

### Fazer login
```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@gymdata.com","senha":"123456"}'
```

Resposta:
```json
{ "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6..." }
```

### Usar o token nas rotas
```bash
curl http://localhost:8080/api/alunos \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

Todas as rotas exceto `POST /api/login` e `POST /api/usuarios` exigem o token JWT.

---

## 7. Documentação Swagger

Após subir os containers, acesse:

**http://localhost:8080/api-docs**

---

## 8. Detalhamento Técnico da Infraestrutura

### Otimização de Imagens
`Dockerfile` com **Multi-stage Build**: estágio `builder` instala dependências, estágio `runtime` copia só o necessário. Imagem base `node:24-alpine` (~5MB). Usuário não-root `appuser` para segurança.

### Persistência
Named Volumes `postgres_data` e `redis_data` — dados sobrevivem a qualquer restart ou recriação dos containers.

### Rede e Comunicação
Rede bridge customizada `app-network`. Comunicação via nome do serviço (DNS interno): `db`, `cache`. IPs estáticos são proibidos. PostgreSQL e Redis sem porta exposta ao host.

### Segurança
Credenciais via `.env` — nunca hardcoded. Node.js privado, acessível apenas via Nginx. Redis protegido por senha.

---

## 9. Gestão de Segredos

```bash
cp .env.example .env
# Edite o .env com seus valores
```

> ⚠️ Nunca commite o `.env` com senhas reais no repositório.

Variáveis necessárias:

```dotenv
DB_NAME=gymdata
DB_USER=gymuser
DB_PASSWORD=gympassword
DB_HOST=db
DB_PORT=5432
JWT_SECRET=troque_por_uma_chave_secreta_longa
PORT=3000
REDIS_HOST=cache
REDIS_PORT=6379
REDIS_PASSWORD=gymredispassword
```

---

## 10. Pipeline CI/CD (deploy.sh)

```bash
chmod +x deploy.sh

# Subir sem push para ECR (desenvolvimento)
./deploy.sh --skip-ecr

# Com push para Amazon ECR (produção)
./deploy.sh

# Destruir tudo
./deploy.sh --down
```

O script cobre: **Build → Tag → ECR Push → Deploy** com evidências automáticas de DNS, volumes e conectividade.

---

## 11. Evidências de Funcionamento

```bash
# Status dos containers
docker compose ps

# DNS interno (resolução por nome, não por IP)
docker exec gymdata_app ping -c 3 db
docker exec gymdata_app ping -c 3 cache

# Redis respondendo
docker exec gymdata_cache redis-cli -a gymredispassword ping

# Inspecionar rede
docker network inspect gymdata_app-network

# Volumes nomeados
docker volume ls | grep gymdata

# Banco inacessível pelo host (deve falhar)
curl http://localhost:5432

# Node inacessível direto (deve falhar)
curl http://localhost:3000
```

---

## 12. Troubleshooting e Limpeza

### Problemas comuns

| Sintoma | Solução |
|---|---|
| `app` reiniciando | Aguarde `db` e `cache` ficarem healthy |
| 502 Bad Gateway | `docker compose logs app` para ver o erro |
| Migrations falhando | Verifique se o `.env` está correto |

### Diagnóstico

```bash
docker compose logs app
docker compose logs db
docker compose logs cache
```

### Limpeza completa

```bash
# Para e remove containers (dados preservados)
docker compose down

# Remove tudo incluindo volumes (reset total)
docker compose down -v

# Via script
./deploy.sh --down
```

---

## 13. Banco de Dados

Os arquivos da prova de Banco de Dados estão em `banco-de-dados/`:

```
banco-de-dados/
├── modelagem/
│   ├── der.png
│   ├── modelo_logico.png
│   └── dicionario_dados.md
├── scripts/
│   ├── setup.sql
│   └── seed/seed.sql
├── queries/
│   ├── crud.sql
│   ├── consultas_avancadas.sql
│   └── agregacoes.sql
└── justificativa/
    └── arquitetura.md
```
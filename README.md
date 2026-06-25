# 🏋️ GymData — Sistema de Gerenciamento de Academia

API REST para gerenciamento de academia: alunos, planos, matrículas e treinos.

---

## Containers

| Container | Imagem | Função |
|---|---|---|
| `gymdata_db` | postgres:17-alpine | Banco de dados PostgreSQL |
| `gymdata_app` | node:24-alpine (build local) | API Node.js/Express (privado) |
| `gymdata_nginx` | nginx:alpine | Proxy reverso (porta 8080) |

> O Node.js **não tem porta exposta ao host**. Todo acesso externo passa pelo Nginx.
> Arquitetura: `Host → Nginx:8080 → app:3000 → db:5432`

---

## Como executar o projeto

### 1. Pré-requisitos
- Docker Desktop com WSL2 habilitado
- WSL2 Ubuntu

### 2. Configurar variáveis de ambiente
```bash
cp .env.example .env
```
O `.env.example` já contém valores funcionais para desenvolvimento. Edite se necessário.

### 3. Subir os containers
```bash
docker compose up --build
```

Aguarde todos os containers ficarem healthy. A API estará disponível em:
**http://localhost:8080/api**

---

## Como executar as migrations

Com os containers rodando (ou apenas o `db` healthy), execute:

```bash
docker compose run --rm cli migrate
```

Para recriar todas as tabelas do zero:
```bash
docker compose run --rm cli migrate:fresh
```

> O container `cli` não fica de pé permanentemente — sobe, executa o comando e encerra.
> Conforme orientação do professor: `docker compose run --rm <container> <command>`

---

## Como realizar login e usar o token JWT

### 1. Criar um usuário (primeira vez)
```bash
curl -X POST http://localhost:8080/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nome":"Admin","email":"admin@gymdata.com","senha":"123456"}'
```

### 2. Fazer login para obter o token
```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@gymdata.com","senha":"123456"}'
```

Resposta:
```json
{ "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6..." }
```

### 3. Usar o token nas demais rotas
```bash
curl http://localhost:8080/api/alunos \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

Todas as rotas exceto `POST /api/login` exigem o token JWT no header.

---

## Documentação Swagger

Após subir os containers, acesse:

**http://localhost:8080/api-docs**

A documentação contém todas as rotas com exemplos de request/response e suporte a autenticação Bearer.

---

## Rotas disponíveis

| Método | Rota | Descrição |
|---|---|---|
| POST | /api/login | Login — gera token JWT |
| GET/POST | /api/usuarios | Listar / criar usuários |
| GET/PUT/DELETE | /api/usuarios/:id | Buscar / atualizar / remover |
| GET/POST | /api/alunos | Listar / criar alunos |
| GET/PUT/DELETE | /api/alunos/:id | Buscar / atualizar / remover |
| GET/POST | /api/planos | Listar / criar planos |
| GET/PUT/DELETE | /api/planos/:id | Buscar / atualizar / remover |
| GET/POST | /api/matriculas | Listar / criar matrículas (pivô N:N) |
| GET/PUT/DELETE | /api/matriculas/:id | Buscar / atualizar / remover |
| GET/POST | /api/treinos | Listar / criar treinos |
| GET/PUT/DELETE | /api/treinos/:id | Buscar / atualizar / remover |
| POST | /api/treinos/:id/exercicios | Adicionar exercício ao treino (pivô N:N) |
| DELETE | /api/treinos/:id/exercicios/:exercicio_id | Remover exercício do treino |
| GET/POST | /api/exercicios | Listar / criar exercícios |
| GET/PUT/DELETE | /api/exercicios/:id | Buscar / atualizar / remover |

---

## Limpeza

```bash
# Para os containers sem remover dados
docker compose down

# Para e remove tudo incluindo o volume do banco
docker compose down -v
```
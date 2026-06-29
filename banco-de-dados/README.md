# 🗄️ GymData — Banco de Dados

Documentação completa da modelagem e estrutura do banco de dados do sistema GymData.

---

## Tecnologia

**PostgreSQL 17** — banco relacional escolhido pela robustez em consultas analíticas, suporte a NUMERIC para valores financeiros e conformidade com os requisitos do projeto.

---

## Estrutura de Pastas

```
banco-de-dados/
├── modelagem/
│   ├── der.png               ← Diagrama Entidade-Relacionamento
│   ├── modelo_logico.png     ← Diagrama Lógico com tipos e constraints
│   └── dicionario_dados.md   ← Dicionário de dados completo
├── scripts/
│   ├── setup.sql             ← DDL: cria todas as tabelas e índices
│   └── seed/
│       └── seed.sql          ← Dados de teste (100+ registros)
├── queries/
│   ├── crud.sql              ← CRUD básico por entidade
│   ├── consultas_avancadas.sql ← 7 consultas com JOINs e filtros
│   └── agregacoes.sql        ← 5 consultas de agregação
└── justificativa/
    └── arquitetura.md        ← Justificativa técnica completa
```

---

## Como executar (SQL puro — sem Docker)

### Pré-requisitos
- PostgreSQL 17+ instalado localmente
- `psql` disponível no terminal

### Passo 1 — Criar o banco
```sql
CREATE DATABASE gymdata;
```

### Passo 2 — Criar as tabelas
```bash
psql -U postgres -d gymdata -f scripts/setup.sql
```

### Passo 3 — Inserir dados de teste
```bash
psql -U postgres -d gymdata -f scripts/seed/seed.sql
```

### Passo 4 — Executar as queries
```bash
psql -U postgres -d gymdata -f queries/consultas_avancadas.sql
```

---

## Como executar (via Docker do projeto)

Com o projeto rodando (`docker compose up --build` + migrations):

```bash
# Conectar no banco pelo terminal
docker exec -it gymdata_db psql -U gymuser -d gymdata

# Ou executar um arquivo SQL direto
docker exec -i gymdata_db psql -U gymuser -d gymdata < scripts/setup.sql
```

---

## Conectar no DBeaver

| Campo | Valor |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `gymdata` |
| Username | `gymuser` |
| Password | `gympassword` |

> Para conectar via DBeaver o container precisa ter a porta exposta. Adicione temporariamente no `docker-compose.yml` em `db`: `ports: ["5432:5432"]`

---

## Entidades

| Tabela | Descrição |
|---|---|
| `usuarios` | Administradores e instrutores |
| `alunos` | Cadastro de alunos |
| `planos` | Planos disponíveis |
| `matriculas` | Pivô N:N aluno ↔ plano |
| `treinos` | Programas de treino por aluno |
| `exercicios` | Catálogo de exercícios |
| `treino_exercicios` | Pivô N:N treino ↔ exercício |

---

## Índices criados

| Índice | Tabela | Campo | Motivo |
|---|---|---|---|
| idx_alunos_cpf | alunos | cpf | Busca por CPF |
| idx_alunos_email | alunos | email | Login e duplicidade |
| idx_alunos_ativo | alunos | ativo | Filtro de ativos |
| idx_matriculas_aluno | matriculas | aluno_id | JOIN frequente |
| idx_matriculas_plano | matriculas | plano_id | JOIN frequente |
| idx_matriculas_status | matriculas | status | Filtro por status |
| idx_matriculas_data_fim | matriculas | data_fim | Consultas de vencimento |
| idx_treinos_aluno | treinos | aluno_id | Busca por aluno |
| idx_te_treino | treino_exercicios | treino_id | JOIN na listagem |
| idx_te_exercicio | treino_exercicios | exercicio_id | Ranking de exercícios |
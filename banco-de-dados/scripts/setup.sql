-- GymData — DDL PostgreSQL
-- Execute: psql -U gymuser -d gymdata -f setup.sql

-- Extensão para UUID (opcional)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABELAS
-- =============================================

CREATE TABLE IF NOT EXISTS usuarios (
  id          SERIAL PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  senha       VARCHAR(255) NOT NULL,
  "createdAt" TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt" TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS alunos (
  id               SERIAL PRIMARY KEY,
  nome             VARCHAR(100) NOT NULL,
  email            VARCHAR(150) NOT NULL UNIQUE,
  cpf              VARCHAR(14)  NOT NULL UNIQUE,
  telefone         VARCHAR(20),
  data_nascimento  DATE,
  ativo            BOOLEAN DEFAULT TRUE,
  "createdAt"      TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt"      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS planos (
  id            SERIAL PRIMARY KEY,
  nome          VARCHAR(100) NOT NULL,
  descricao     TEXT,
  preco         NUMERIC(10,2) NOT NULL,
  duracao_dias  INTEGER NOT NULL,
  ativo         BOOLEAN DEFAULT TRUE,
  "createdAt"   TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt"   TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela pivô N:N — alunos <-> planos
CREATE TABLE IF NOT EXISTS matriculas (
  id          SERIAL PRIMARY KEY,
  aluno_id    INTEGER NOT NULL REFERENCES alunos(id) ON DELETE CASCADE,
  plano_id    INTEGER NOT NULL REFERENCES planos(id) ON DELETE RESTRICT,
  data_inicio DATE NOT NULL,
  data_fim    DATE NOT NULL,
  status      VARCHAR(20) DEFAULT 'ativa' CHECK (status IN ('ativa','inativa','cancelada')),
  "createdAt" TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt" TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS exercicios (
  id              SERIAL PRIMARY KEY,
  nome            VARCHAR(100) NOT NULL,
  grupo_muscular  VARCHAR(80),
  descricao       TEXT,
  "createdAt"     TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt"     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS treinos (
  id          SERIAL PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL,
  aluno_id    INTEGER NOT NULL REFERENCES alunos(id) ON DELETE CASCADE,
  observacoes TEXT,
  "createdAt" TIMESTAMPTZ DEFAULT NOW(),
  "updatedAt" TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela pivô N:N — treinos <-> exercicios
CREATE TABLE IF NOT EXISTS treino_exercicios (
  id            SERIAL PRIMARY KEY,
  treino_id     INTEGER NOT NULL REFERENCES treinos(id) ON DELETE CASCADE,
  exercicio_id  INTEGER NOT NULL REFERENCES exercicios(id) ON DELETE CASCADE,
  series        INTEGER DEFAULT 3,
  repeticoes    INTEGER DEFAULT 12,
  carga_kg      NUMERIC(5,2),
  UNIQUE(treino_id, exercicio_id)
);

-- =============================================
-- ÍNDICES
-- =============================================

CREATE INDEX IF NOT EXISTS idx_alunos_cpf         ON alunos(cpf);
CREATE INDEX IF NOT EXISTS idx_alunos_email        ON alunos(email);
CREATE INDEX IF NOT EXISTS idx_alunos_ativo        ON alunos(ativo);
CREATE INDEX IF NOT EXISTS idx_matriculas_aluno    ON matriculas(aluno_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_plano    ON matriculas(plano_id);
CREATE INDEX IF NOT EXISTS idx_matriculas_status   ON matriculas(status);
CREATE INDEX IF NOT EXISTS idx_matriculas_data_fim ON matriculas(data_fim);
CREATE INDEX IF NOT EXISTS idx_treinos_aluno       ON treinos(aluno_id);
CREATE INDEX IF NOT EXISTS idx_te_treino           ON treino_exercicios(treino_id);
CREATE INDEX IF NOT EXISTS idx_te_exercicio        ON treino_exercicios(exercicio_id);
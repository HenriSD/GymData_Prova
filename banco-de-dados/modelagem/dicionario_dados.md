# Dicionário de Dados — GymData

## Tabela: `usuarios`
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome completo |
| email | VARCHAR(150) | NOT NULL, UNIQUE | E-mail de login |
| senha | VARCHAR(255) | NOT NULL | Senha criptografada (bcrypt) |
| createdAt | TIMESTAMPTZ | DEFAULT NOW() | Data de criação |
| updatedAt | TIMESTAMPTZ | DEFAULT NOW() | Data de atualização |

## Tabela: `alunos`
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome completo |
| email | VARCHAR(150) | NOT NULL, UNIQUE | E-mail do aluno |
| cpf | VARCHAR(14) | NOT NULL, UNIQUE | CPF formatado |
| telefone | VARCHAR(20) | — | Telefone de contato |
| data_nascimento | DATE | — | Data de nascimento |
| ativo | BOOLEAN | DEFAULT TRUE | Se o aluno está ativo |
| createdAt | TIMESTAMPTZ | DEFAULT NOW() | Data de criação |
| updatedAt | TIMESTAMPTZ | DEFAULT NOW() | Data de atualização |

## Tabela: `planos`
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome do plano |
| descricao | TEXT | — | Descrição detalhada |
| preco | NUMERIC(10,2) | NOT NULL | Valor em R$ |
| duracao_dias | INTEGER | NOT NULL | Duração em dias |
| ativo | BOOLEAN | DEFAULT TRUE | Se o plano está disponível |

## Tabela: `matriculas` *(pivô N:N — alunos ↔ planos)*
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| aluno_id | INTEGER | FK → alunos(id) | Referência ao aluno |
| plano_id | INTEGER | FK → planos(id) | Referência ao plano |
| data_inicio | DATE | NOT NULL | Início da vigência |
| data_fim | DATE | NOT NULL | Fim da vigência |
| status | VARCHAR(20) | CHECK ENUM | ativa / inativa / cancelada |

## Tabela: `exercicios`
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome do exercício |
| grupo_muscular | VARCHAR(80) | — | Grupo muscular trabalhado |
| descricao | TEXT | — | Descrição da execução |

## Tabela: `treinos`
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| nome | VARCHAR(100) | NOT NULL | Nome do treino |
| aluno_id | INTEGER | FK → alunos(id) | Dono do treino |
| observacoes | TEXT | — | Observações do instrutor |

## Tabela: `treino_exercicios` *(pivô N:N — treinos ↔ exercicios)*
| Coluna | Tipo | Restrições | Descrição |
|---|---|---|---|
| id | SERIAL | PK | Identificador único |
| treino_id | INTEGER | FK → treinos(id) | Referência ao treino |
| exercicio_id | INTEGER | FK → exercicios(id) | Referência ao exercício |
| series | INTEGER | DEFAULT 3 | Número de séries |
| repeticoes | INTEGER | DEFAULT 12 | Número de repetições |
| carga_kg | NUMERIC(5,2) | — | Carga em kg |
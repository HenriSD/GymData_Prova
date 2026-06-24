# Justificativa Arquitetural — GymData

## 1. Escolha Tecnológica: PostgreSQL (SQL Relacional)

### Por que SQL e não NoSQL?

O GymData gerencia **dados fortemente relacionados**: um aluno possui matrículas, cada matrícula vincula um plano, cada treino pertence a um aluno e contém exercícios. Essa natureza relacional favorece o modelo SQL, que garante integridade referencial via chaves estrangeiras — se um aluno for removido, suas matrículas e treinos são removidos em cascata automaticamente (ON DELETE CASCADE).

Bancos NoSQL como MongoDB seriam adequados para dados menos estruturados (ex: logs, documentos livres), mas trariam redundância e inconsistências no cenário de academia, onde os mesmos planos são referenciados por centenas de matrículas.

### Por que PostgreSQL e não MySQL?

O PostgreSQL foi escolhido pelos seguintes motivos:

- **Conformidade com o requisito da disciplina** de Desenvolvimento Web, que exige PostgreSQL 17+.
- **Suporte nativo a tipos avançados**: NUMERIC para valores financeiros sem arredondamento de ponto flutuante, ENUM via CHECK constraint, TIMESTAMPTZ com fuso horário.
- **Performance em consultas analíticas**: window functions e aggregations mais robustas, úteis para relatórios de receita e rankings.
- **Melhor suporte a integridade transacional (ACID)**, essencial para operações financeiras como matrículas e pagamentos.

---

## 2. Normalização

### 1ª Forma Normal (1FN)
Todas as tabelas possuem atributos atômicos (sem grupos repetidos ou arrays em colunas). Exemplo: os exercícios de um treino não ficam em uma coluna do tipo array dentro de `treinos` — estão na tabela pivô `treino_exercicios`.

### 2ª Forma Normal (2FN)
Todos os atributos não-chave dependem funcionalmente da chave primária inteira. Na tabela `treino_exercicios`, os atributos `series`, `repeticoes` e `carga_kg` dependem do par (treino_id, exercicio_id), não apenas de um dos campos isoladamente.

### 3ª Forma Normal (3FN)
Nenhum atributo não-chave depende de outro atributo não-chave (sem dependências transitivas). Exemplo: o `preco` do plano está em `planos`, não em `matriculas` — se o preço mudar, altera-se apenas em um lugar.

### Desnormalização aplicada
A coluna `data_fim` em `matriculas` é tecnicamente derivável de `data_inicio + plano.duracao_dias`, mas foi mantida como campo explícito para **performance de consulta**: filtrar matrículas vencendo nos próximos 30 dias via `WHERE data_fim BETWEEN ...` usa diretamente o índice `idx_matriculas_data_fim`, sem necessidade de cálculo em tempo de execução.

---

## 3. Estratégia de Indexação

| Índice | Tabela | Campo | Tipo | Justificativa |
|---|---|---|---|---|
| idx_alunos_cpf | alunos | cpf | B-Tree | Busca de aluno por CPF (operação frequente) |
| idx_alunos_email | alunos | email | B-Tree | Login e verificação de duplicidade |
| idx_alunos_ativo | alunos | ativo | B-Tree | Filtro de alunos ativos no dashboard |
| idx_matriculas_aluno | matriculas | aluno_id | B-Tree | JOIN frequente com alunos |
| idx_matriculas_plano | matriculas | plano_id | B-Tree | JOIN frequente com planos |
| idx_matriculas_status | matriculas | status | B-Tree | Filtro por status (ativa/inativa/cancelada) |
| idx_matriculas_data_fim | matriculas | data_fim | B-Tree | Consulta de vencimentos por período |
| idx_treinos_aluno | treinos | aluno_id | B-Tree | Busca de treinos por aluno |
| idx_te_treino | treino_exercicios | treino_id | B-Tree | JOIN na listagem de exercícios do treino |
| idx_te_exercicio | treino_exercicios | exercicio_id | B-Tree | Ranking de exercícios mais usados |

---

## 4. Decisão: RDS vs EC2 / S3 vs EFS (contexto AWS)

Para o cenário de infraestrutura web da avaliação:

- **RDS (PostgreSQL gerenciado)** é preferível a instalar PostgreSQL em EC2 porque elimina overhead de administração (backups, patches, failover). A configuração **Multi-AZ** garante alta disponibilidade automática.
- **S3** é o armazenamento correto para assets estáticos (fotos de exercícios, PDFs de ficha) pela durabilidade de 11 noves e custo por objeto. EFS seria excessivo para este caso — é adequado para sistemas de arquivos compartilhados entre múltiplas instâncias EC2.
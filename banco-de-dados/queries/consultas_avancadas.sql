-- GymData — Consultas Avançadas
-- Banco: PostgreSQL

-- =============================================
-- 1. Alunos com matrícula ativa e seu plano atual
-- Uso: relatório de alunos ativos; JOIN entre alunos, matriculas e planos
-- =============================================
SELECT
  a.id,
  a.nome,
  a.cpf,
  p.nome        AS plano,
  p.preco,
  m.data_inicio,
  m.data_fim,
  m.status
FROM alunos a
JOIN matriculas m ON m.aluno_id = a.id
JOIN planos    p ON p.id = m.plano_id
WHERE m.status = 'ativa'
  AND a.ativo = true
ORDER BY m.data_fim ASC;

-- =============================================
-- 2. Receita total por plano (agregação)
-- Uso: relatório financeiro; GROUP BY com SUM
-- =============================================
SELECT
  p.nome                            AS plano,
  COUNT(m.id)                       AS total_matriculas,
  SUM(p.preco)                      AS receita_total,
  ROUND(AVG(p.preco), 2)            AS ticket_medio
FROM planos p
JOIN matriculas m ON m.plano_id = p.id
WHERE m.status = 'ativa'
GROUP BY p.id, p.nome
ORDER BY receita_total DESC;

-- =============================================
-- 3. Alunos com matrícula vencendo nos próximos 30 dias
-- Uso: disparo de renovação; filtro por data com intervalo
-- =============================================
SELECT
  a.nome,
  a.email,
  a.telefone,
  p.nome        AS plano,
  m.data_fim,
  (m.data_fim - CURRENT_DATE) AS dias_restantes
FROM alunos a
JOIN matriculas m ON m.aluno_id = a.id
JOIN planos    p ON p.id = m.plano_id
WHERE m.status = 'ativa'
  AND m.data_fim BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days')
ORDER BY m.data_fim ASC;

-- =============================================
-- 4. Exercícios mais utilizados nos treinos (ranking)
-- Uso: gestão de equipamentos; agregação com COUNT e ORDER BY
-- =============================================
SELECT
  e.nome                      AS exercicio,
  e.grupo_muscular,
  COUNT(te.id)                AS vezes_utilizado,
  ROUND(AVG(te.carga_kg), 2)  AS carga_media_kg,
  ROUND(AVG(te.series), 1)    AS series_media,
  ROUND(AVG(te.repeticoes), 1)AS reps_media
FROM exercicios e
JOIN treino_exercicios te ON te.exercicio_id = e.id
GROUP BY e.id, e.nome, e.grupo_muscular
ORDER BY vezes_utilizado DESC
LIMIT 10;

-- =============================================
-- 5. Histórico completo de um aluno (treinos + exercícios)
-- Uso: ficha do aluno; múltiplos JOINs
-- =============================================
SELECT
  a.nome                AS aluno,
  t.nome                AS treino,
  e.nome                AS exercicio,
  e.grupo_muscular,
  te.series,
  te.repeticoes,
  te.carga_kg
FROM alunos a
JOIN treinos          t  ON t.aluno_id    = a.id
JOIN treino_exercicios te ON te.treino_id  = t.id
JOIN exercicios        e  ON e.id          = te.exercicio_id
WHERE a.id = 1
ORDER BY t.nome, e.grupo_muscular;

-- =============================================
-- 6. Contagem de alunos por status de matrícula
-- Uso: dashboard; GROUP BY com ENUM
-- =============================================
SELECT
  m.status,
  COUNT(DISTINCT m.aluno_id) AS total_alunos
FROM matriculas m
GROUP BY m.status;

-- =============================================
-- 7. Alunos sem nenhuma matrícula (LEFT JOIN)
-- Uso: identificar cadastros incompletos
-- =============================================
SELECT a.id, a.nome, a.email, a."createdAt"
FROM alunos a
LEFT JOIN matriculas m ON m.aluno_id = a.id
WHERE m.id IS NULL
ORDER BY a."createdAt" DESC;
-- GymData — Consultas de Agregação

-- =============================================
-- 1. Receita total e ticket médio por plano
-- =============================================
SELECT
  p.nome                              AS plano,
  COUNT(m.id)                         AS total_matriculas,
  SUM(p.preco)                        AS receita_total,
  ROUND(AVG(p.preco), 2)              AS ticket_medio,
  MIN(m.data_inicio)                  AS primeira_matricula
FROM planos p
JOIN matriculas m ON m.plano_id = p.id
GROUP BY p.id, p.nome
ORDER BY receita_total DESC;

-- =============================================
-- 2. Contagem de alunos por status de matrícula
-- =============================================
SELECT
  m.status,
  COUNT(DISTINCT m.aluno_id)          AS total_alunos,
  ROUND(COUNT(DISTINCT m.aluno_id) * 100.0 /
    SUM(COUNT(DISTINCT m.aluno_id)) OVER (), 1) AS percentual
FROM matriculas m
GROUP BY m.status
ORDER BY total_alunos DESC;

-- =============================================
-- 3. Top 5 exercícios mais usados
-- =============================================
SELECT
  e.nome                              AS exercicio,
  e.grupo_muscular,
  COUNT(te.id)                        AS vezes_utilizado,
  ROUND(AVG(te.carga_kg), 2)          AS carga_media_kg
FROM exercicios e
JOIN treino_exercicios te ON te.exercicio_id = e.id
GROUP BY e.id, e.nome, e.grupo_muscular
ORDER BY vezes_utilizado DESC
LIMIT 5;

-- =============================================
-- 4. Matrículas por mês (série temporal)
-- =============================================
SELECT
  TO_CHAR(data_inicio, 'YYYY-MM')     AS mes,
  COUNT(*)                            AS novas_matriculas,
  SUM(COUNT(*)) OVER (
    ORDER BY TO_CHAR(data_inicio, 'YYYY-MM')
  )                                   AS acumulado
FROM matriculas
GROUP BY TO_CHAR(data_inicio, 'YYYY-MM')
ORDER BY mes;

-- =============================================
-- 5. Média de exercícios por treino
-- =============================================
SELECT
  a.nome                              AS aluno,
  COUNT(DISTINCT t.id)                AS total_treinos,
  COUNT(te.id)                        AS total_exercicios,
  ROUND(COUNT(te.id)::numeric /
    NULLIF(COUNT(DISTINCT t.id), 0), 1) AS media_exercicios_por_treino
FROM alunos a
JOIN treinos t             ON t.aluno_id    = a.id
LEFT JOIN treino_exercicios te ON te.treino_id = t.id
GROUP BY a.id, a.nome
ORDER BY media_exercicios_por_treino DESC;
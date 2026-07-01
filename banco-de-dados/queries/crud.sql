-- GymData — CRUD básico por entidade

-- =============================================
-- USUARIOS
-- =============================================
-- Create
INSERT INTO usuarios (nome, email, senha, "createdAt", "updatedAt")
  VALUES ('Novo Admin', 'novo@gymdata.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW(), NOW());
-- Read
SELECT id, nome, email, "createdAt" FROM usuarios;
SELECT id, nome, email FROM usuarios WHERE id = 1;
-- Update
UPDATE usuarios SET nome = 'Admin Atualizado' WHERE id = 1;
-- Delete
DELETE FROM usuarios WHERE id = 4;

-- =============================================
-- ALUNOS
-- =============================================
-- Create
INSERT INTO alunos (nome, email, cpf, telefone, "data_nascimento", ativo, "createdAt", "updatedAt")
  VALUES ('Teste Silva', 'teste@email.com', '999.999.999-99', '(11)99999-9999', '2000-01-01', true, NOW(), NOW());
-- Read
SELECT * FROM alunos ORDER BY nome;
SELECT * FROM alunos WHERE id = 1;
-- Update
UPDATE alunos SET telefone = '(11)98888-8888', ativo = false WHERE id = 1;
-- Delete
DELETE FROM alunos WHERE cpf = '999.999.999-99';

-- =============================================
-- PLANOS
-- =============================================
-- Create
INSERT INTO planos (nome, descricao, preco, "duracao_dias", ativo, "createdAt", "updatedAt")
  VALUES ('Plano Teste', 'Descrição', 99.90, 30, true, NOW(), NOW());
-- Read
SELECT * FROM planos WHERE ativo = true ORDER BY preco;
SELECT * FROM planos WHERE id = 1;
-- Update
UPDATE planos SET preco = 109.90 WHERE nome = 'Plano Teste';
-- Delete
DELETE FROM planos WHERE nome = 'Plano Teste';

-- =============================================
-- MATRICULAS (pivô N:N)
-- =============================================
-- Create
INSERT INTO matriculas ("aluno_id", "plano_id", "data_inicio", "data_fim", status, "createdAt", "updatedAt")
  VALUES (1, 2, '2025-06-01', '2025-06-30', 'ativa', NOW(), NOW());
-- Read
SELECT m.*, a.nome AS aluno, p.nome AS plano
FROM matriculas m
JOIN alunos a ON a.id = m."aluno_id"
JOIN planos  p ON p.id = m."plano_id";
SELECT * FROM matriculas WHERE id = 1;
-- Update
UPDATE matriculas SET status = 'cancelada' WHERE id = 1;
-- Delete
DELETE FROM matriculas WHERE id = 1;

-- =============================================
-- TREINOS
-- =============================================
-- Create
INSERT INTO treinos (nome, "aluno_id", observacoes, "createdAt", "updatedAt")
  VALUES ('Treino Teste', 1, 'Obs de teste', NOW(), NOW());
-- Read
SELECT t.*, a.nome AS aluno FROM treinos t JOIN alunos a ON a.id = t."aluno_id";
SELECT * FROM treinos WHERE id = 1;
-- Update
UPDATE treinos SET nome = 'Treino Atualizado' WHERE nome = 'Treino Teste';
-- Delete
DELETE FROM treinos WHERE nome = 'Treino Atualizado';

-- =============================================
-- EXERCICIOS
-- =============================================
-- Create
INSERT INTO exercicios (nome, "grupo_muscular", descricao, "createdAt", "updatedAt")
  VALUES ('Exercício Teste', 'Peito', 'Descrição do exercício', NOW(), NOW());
-- Read
SELECT * FROM exercicios ORDER BY "grupo_muscular", nome;
SELECT * FROM exercicios WHERE id = 1;
-- Update
UPDATE exercicios SET descricao = 'Descrição atualizada' WHERE nome = 'Exercício Teste';
-- Delete
DELETE FROM exercicios WHERE nome = 'Exercício Teste';

-- =============================================
-- TREINO_EXERCICIOS (pivô N:N)
-- =============================================
-- Create
INSERT INTO treino_exercicios ("treino_id", "exercicio_id", series, repeticoes, "carga_kg")
  VALUES (1, 1, 4, 10, 50.0);
-- Read
SELECT te.*, t.nome AS treino, e.nome AS exercicio
FROM treino_exercicios te
JOIN treinos    t ON t.id = te."treino_id"
JOIN exercicios e ON e.id = te."exercicio_id"
WHERE te."treino_id" = 1;
-- Update
UPDATE treino_exercicios SET "carga_kg" = 55.0 WHERE "treino_id" = 1 AND "exercicio_id" = 1;
-- Delete
DELETE FROM treino_exercicios WHERE "treino_id" = 1 AND "exercicio_id" = 1;
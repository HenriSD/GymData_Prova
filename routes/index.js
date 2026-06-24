const router = require('express').Router();
const auth = require('../app/Middlewares/auth');
const logger = require('../app/Middlewares/logger');

const AuthController      = require('../app/Controllers/AuthController');
const UsuarioController   = require('../app/Controllers/UsuarioController');
const AlunoController     = require('../app/Controllers/AlunoController');
const PlanoController     = require('../app/Controllers/PlanoController');
const MatriculaController = require('../app/Controllers/MatriculaController');
const TreinoController    = require('../app/Controllers/TreinoController');
const ExercicioController = require('../app/Controllers/ExercicioController');

// Logger em todas as rotas
router.use(logger);

// Rotas públicas (sem JWT)
router.post('/login',    AuthController.login);
router.post('/usuarios', UsuarioController.create); // criar primeiro usuário

// Todas as rotas abaixo exigem JWT
router.use(auth);

// Usuários
router.get('/usuarios',        UsuarioController.index);
router.get('/usuarios/:id',    UsuarioController.show);
router.put('/usuarios/:id',    UsuarioController.update);
router.delete('/usuarios/:id', UsuarioController.destroy);

// Alunos
router.get('/alunos',          AlunoController.index);
router.get('/alunos/:id',      AlunoController.show);
router.post('/alunos',         AlunoController.create);
router.put('/alunos/:id',      AlunoController.update);
router.delete('/alunos/:id',   AlunoController.destroy);

// Planos
router.get('/planos',          PlanoController.index);
router.get('/planos/:id',      PlanoController.show);
router.post('/planos',         PlanoController.create);
router.put('/planos/:id',      PlanoController.update);
router.delete('/planos/:id',   PlanoController.destroy);

// Matrículas
router.get('/matriculas',         MatriculaController.index);
router.get('/matriculas/:id',     MatriculaController.show);
router.post('/matriculas',        MatriculaController.create);
router.put('/matriculas/:id',     MatriculaController.update);
router.delete('/matriculas/:id',  MatriculaController.destroy);

// Treinos
router.get('/treinos',         TreinoController.index);
router.get('/treinos/:id',     TreinoController.show);
router.post('/treinos',        TreinoController.create);
router.put('/treinos/:id',     TreinoController.update);
router.delete('/treinos/:id',  TreinoController.destroy);

// Exercícios do treino (pivô N:N)
router.post('/treinos/:id/exercicios',                   TreinoController.addExercicio);
router.delete('/treinos/:id/exercicios/:exercicio_id',   TreinoController.removeExercicio);

// Exercícios
router.get('/exercicios',         ExercicioController.index);
router.get('/exercicios/:id',     ExercicioController.show);
router.post('/exercicios',        ExercicioController.create);
router.put('/exercicios/:id',     ExercicioController.update);
router.delete('/exercicios/:id',  ExercicioController.destroy);

module.exports = router;
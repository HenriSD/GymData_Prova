const { Treino, Exercicio, TreinoExercicio, Aluno } = require('../Models');

module.exports = {
  async index(req, res) {
    const treinos = await Treino.findAll({ include: [Aluno, { model: Exercicio, through: { attributes: ['series', 'repeticoes', 'carga_kg'] } }] });
    res.json(treinos);
  },

  async show(req, res) {
    const treino = await Treino.findByPk(req.params.id, {
      include: [Aluno, { model: Exercicio, through: { attributes: ['series', 'repeticoes', 'carga_kg'] } }],
    });
    if (!treino) return res.status(404).json({ error: 'Não encontrado' });
    res.json(treino);
  },

  async create(req, res) {
    try {
      const treino = await Treino.create(req.body);
      res.status(201).json(treino);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const treino = await Treino.findByPk(req.params.id);
      if (!treino) return res.status(404).json({ error: 'Não encontrado' });
      await treino.update(req.body);
      res.json(treino);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const treino = await Treino.findByPk(req.params.id);
    if (!treino) return res.status(404).json({ error: 'Não encontrado' });
    await treino.destroy();
    res.status(204).send();
  },

  // Adicionar exercício ao treino
  async addExercicio(req, res) {
    try {
      const { exercicio_id, series, repeticoes, carga_kg } = req.body;
      const rel = await TreinoExercicio.create({ treino_id: req.params.id, exercicio_id, series, repeticoes, carga_kg });
      res.status(201).json(rel);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  // Remover exercício do treino
  async removeExercicio(req, res) {
    await TreinoExercicio.destroy({ where: { treino_id: req.params.id, exercicio_id: req.params.exercicio_id } });
    res.status(204).send();
  },
};
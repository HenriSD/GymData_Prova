const { Exercicio } = require('../Models');

module.exports = {
  async index(req, res) {
    const exercicios = await Exercicio.findAll();
    res.json(exercicios);
  },

  async show(req, res) {
    const exercicio = await Exercicio.findByPk(req.params.id);
    if (!exercicio) return res.status(404).json({ error: 'Não encontrado' });
    res.json(exercicio);
  },

  async create(req, res) {
    try {
      const exercicio = await Exercicio.create(req.body);
      res.status(201).json(exercicio);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const exercicio = await Exercicio.findByPk(req.params.id);
      if (!exercicio) return res.status(404).json({ error: 'Não encontrado' });
      await exercicio.update(req.body);
      res.json(exercicio);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const exercicio = await Exercicio.findByPk(req.params.id);
    if (!exercicio) return res.status(404).json({ error: 'Não encontrado' });
    await exercicio.destroy();
    res.status(204).send();
  },
};
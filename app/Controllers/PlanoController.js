const { Plano } = require('../Models');

module.exports = {
  async index(req, res) {
    const planos = await Plano.findAll();
    res.json(planos);
  },

  async show(req, res) {
    const plano = await Plano.findByPk(req.params.id);
    if (!plano) return res.status(404).json({ error: 'Não encontrado' });
    res.json(plano);
  },

  async create(req, res) {
    try {
      const plano = await Plano.create(req.body);
      res.status(201).json(plano);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const plano = await Plano.findByPk(req.params.id);
      if (!plano) return res.status(404).json({ error: 'Não encontrado' });
      await plano.update(req.body);
      res.json(plano);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const plano = await Plano.findByPk(req.params.id);
    if (!plano) return res.status(404).json({ error: 'Não encontrado' });
    await plano.destroy();
    res.status(204).send();
  },
};
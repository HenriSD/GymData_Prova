const { Matricula, Aluno, Plano } = require('../Models');

module.exports = {
  async index(req, res) {
    const matriculas = await Matricula.findAll({ include: [Aluno, Plano] });
    res.json(matriculas);
  },

  async show(req, res) {
    const matricula = await Matricula.findByPk(req.params.id, { include: [Aluno, Plano] });
    if (!matricula) return res.status(404).json({ error: 'Não encontrado' });
    res.json(matricula);
  },

  async create(req, res) {
    try {
      const matricula = await Matricula.create(req.body);
      res.status(201).json(matricula);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const matricula = await Matricula.findByPk(req.params.id);
      if (!matricula) return res.status(404).json({ error: 'Não encontrado' });
      await matricula.update(req.body);
      res.json(matricula);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const matricula = await Matricula.findByPk(req.params.id);
    if (!matricula) return res.status(404).json({ error: 'Não encontrado' });
    await matricula.destroy();
    res.status(204).send();
  },
};
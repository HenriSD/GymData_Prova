const { Aluno } = require('../Models');

module.exports = {
  async index(req, res) {
    const alunos = await Aluno.findAll();
    res.json(alunos);
  },

  async show(req, res) {
    const aluno = await Aluno.findByPk(req.params.id);
    if (!aluno) return res.status(404).json({ error: 'Não encontrado' });
    res.json(aluno);
  },

  async create(req, res) {
    try {
      const aluno = await Aluno.create(req.body);
      res.status(201).json(aluno);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const aluno = await Aluno.findByPk(req.params.id);
      if (!aluno) return res.status(404).json({ error: 'Não encontrado' });
      await aluno.update(req.body);
      res.json(aluno);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const aluno = await Aluno.findByPk(req.params.id);
    if (!aluno) return res.status(404).json({ error: 'Não encontrado' });
    await aluno.destroy();
    res.status(204).send();
  },
};
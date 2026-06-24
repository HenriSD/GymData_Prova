const bcrypt = require('bcrypt');
const { Usuario } = require('../Models');

module.exports = {
  async index(req, res) {
    const usuarios = await Usuario.findAll({ attributes: { exclude: ['senha'] } });
    res.json(usuarios);
  },

  async show(req, res) {
    const usuario = await Usuario.findByPk(req.params.id, { attributes: { exclude: ['senha'] } });
    if (!usuario) return res.status(404).json({ error: 'Não encontrado' });
    res.json(usuario);
  },

  async create(req, res) {
    try {
      const { nome, email, senha } = req.body;
      const hash = await bcrypt.hash(senha, 10);
      const usuario = await Usuario.create({ nome, email, senha: hash });
      res.status(201).json({ id: usuario.id, nome: usuario.nome, email: usuario.email });
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async update(req, res) {
    try {
      const usuario = await Usuario.findByPk(req.params.id);
      if (!usuario) return res.status(404).json({ error: 'Não encontrado' });
      const { nome, email, senha } = req.body;
      if (senha) req.body.senha = await bcrypt.hash(senha, 10);
      await usuario.update({ nome, email, senha: req.body.senha });
      res.json({ id: usuario.id, nome: usuario.nome, email: usuario.email });
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  },

  async destroy(req, res) {
    const usuario = await Usuario.findByPk(req.params.id);
    if (!usuario) return res.status(404).json({ error: 'Não encontrado' });
    await usuario.destroy();
    res.status(204).send();
  },
};
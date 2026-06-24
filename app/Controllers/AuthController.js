const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Usuario } = require('../Models');

module.exports = {
  async login(req, res) {
    const { email, senha } = req.body;
    try {
      const usuario = await Usuario.findOne({ where: { email } });
      if (!usuario) return res.status(401).json({ error: 'Credenciais inválidas' });

      const valido = await bcrypt.compare(senha, usuario.senha);
      if (!valido) return res.status(401).json({ error: 'Credenciais inválidas' });

      const token = jwt.sign(
        { id: usuario.id, email: usuario.email },
        process.env.JWT_SECRET,
        { expiresIn: '8h' }
      );
      res.json({ token });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  },
};
const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Usuario = sequelize.define('Usuario', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nome: { type: DataTypes.STRING, allowNull: false },
  email: { type: DataTypes.STRING, allowNull: false, unique: true },
  senha: { type: DataTypes.STRING, allowNull: false },
}, { tableName: 'usuarios', timestamps: true });

module.exports = Usuario;
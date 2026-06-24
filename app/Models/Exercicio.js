const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Exercicio = sequelize.define('Exercicio', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nome: { type: DataTypes.STRING, allowNull: false },
  grupo_muscular: { type: DataTypes.STRING },
  descricao: { type: DataTypes.TEXT },
}, { tableName: 'exercicios', timestamps: true });

module.exports = Exercicio;
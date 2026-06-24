const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Plano = sequelize.define('Plano', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nome: { type: DataTypes.STRING, allowNull: false },
  descricao: { type: DataTypes.TEXT },
  preco: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
  duracao_dias: { type: DataTypes.INTEGER, allowNull: false },
  ativo: { type: DataTypes.BOOLEAN, defaultValue: true },
}, { tableName: 'planos', timestamps: true });

module.exports = Plano;
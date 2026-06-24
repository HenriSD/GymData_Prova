const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Treino = sequelize.define('Treino', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nome: { type: DataTypes.STRING, allowNull: false },
  aluno_id: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'alunos', key: 'id' } },
  observacoes: { type: DataTypes.TEXT },
}, { tableName: 'treinos', timestamps: true });

module.exports = Treino;
const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Matricula = sequelize.define('Matricula', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  aluno_id: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'alunos', key: 'id' } },
  plano_id: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'planos', key: 'id' } },
  data_inicio: { type: DataTypes.DATEONLY, allowNull: false },
  data_fim: { type: DataTypes.DATEONLY, allowNull: false },
  status: { type: DataTypes.ENUM('ativa', 'inativa', 'cancelada'), defaultValue: 'ativa' },
}, { tableName: 'matriculas', timestamps: true });

module.exports = Matricula;
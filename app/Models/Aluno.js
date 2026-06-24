const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const Aluno = sequelize.define('Aluno', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  nome: { type: DataTypes.STRING, allowNull: false },
  email: { type: DataTypes.STRING, allowNull: false, unique: true },
  cpf: { type: DataTypes.STRING(14), allowNull: false, unique: true },
  telefone: { type: DataTypes.STRING(20) },
  data_nascimento: { type: DataTypes.DATEONLY },
  ativo: { type: DataTypes.BOOLEAN, defaultValue: true },
}, { tableName: 'alunos', timestamps: true });

module.exports = Aluno;
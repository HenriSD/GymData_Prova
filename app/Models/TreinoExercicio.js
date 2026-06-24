const { DataTypes } = require('sequelize');
const { sequelize } = require('../../database/connections/postgres');

const TreinoExercicio = sequelize.define('TreinoExercicio', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  treino_id: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'treinos', key: 'id' } },
  exercicio_id: { type: DataTypes.INTEGER, allowNull: false, references: { model: 'exercicios', key: 'id' } },
  series: { type: DataTypes.INTEGER, defaultValue: 3 },
  repeticoes: { type: DataTypes.INTEGER, defaultValue: 12 },
  carga_kg: { type: DataTypes.DECIMAL(5, 2) },
}, { tableName: 'treino_exercicios', timestamps: false });

module.exports = TreinoExercicio;
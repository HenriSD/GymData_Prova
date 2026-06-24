const Usuario = require('./Usuario');
const Aluno = require('./Aluno');
const Plano = require('./Plano');
const Matricula = require('./Matricula');
const Treino = require('./Treino');
const Exercicio = require('./Exercicio');
const TreinoExercicio = require('./TreinoExercicio');

// Aluno <-> Plano (N:N via Matricula)
Aluno.belongsToMany(Plano, { through: Matricula, foreignKey: 'aluno_id' });
Plano.belongsToMany(Aluno, { through: Matricula, foreignKey: 'plano_id' });
Aluno.hasMany(Matricula, { foreignKey: 'aluno_id' });
Matricula.belongsTo(Aluno, { foreignKey: 'aluno_id' });
Matricula.belongsTo(Plano, { foreignKey: 'plano_id' });

// Treino <-> Exercicio (N:N via TreinoExercicio)
Treino.belongsToMany(Exercicio, { through: TreinoExercicio, foreignKey: 'treino_id' });
Exercicio.belongsToMany(Treino, { through: TreinoExercicio, foreignKey: 'exercicio_id' });
Treino.hasMany(TreinoExercicio, { foreignKey: 'treino_id' });
TreinoExercicio.belongsTo(Treino, { foreignKey: 'treino_id' });
TreinoExercicio.belongsTo(Exercicio, { foreignKey: 'exercicio_id' });

// Aluno -> Treinos
Aluno.hasMany(Treino, { foreignKey: 'aluno_id' });
Treino.belongsTo(Aluno, { foreignKey: 'aluno_id' });

module.exports = { Usuario, Aluno, Plano, Matricula, Treino, Exercicio, TreinoExercicio };
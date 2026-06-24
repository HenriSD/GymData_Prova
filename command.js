require('dotenv').config();
// IMPORTANTE: importar todos os models para que o sequelize.sync() crie as tabelas
require('./app/Models/index');
const { sequelize } = require('./database/connections/postgres');

const command = process.argv[2];

async function migrate() {
  try {
    console.log('Executando migrations...');
    await sequelize.sync({ force: false });
    console.log('Migrations concluídas com sucesso!');
    process.exit(0);
  } catch (err) {
    console.error('Erro ao executar migrations:', err);
    process.exit(1);
  }
}

async function migrateFresh() {
  try {
    console.log('Recriando todas as tabelas...');
    await sequelize.sync({ force: true });
    console.log('Banco recriado com sucesso!');
    process.exit(0);
  } catch (err) {
    console.error('Erro:', err);
    process.exit(1);
  }
}

switch (command) {
  case 'migrate':
    migrate();
    break;
  case 'migrate:fresh':
    migrateFresh();
    break;
  default:
    console.log('Comandos disponíveis:');
    console.log('  node command.js migrate        - Cria tabelas (sem apagar dados)');
    console.log('  node command.js migrate:fresh  - Recria todas as tabelas');
    process.exit(0);
}
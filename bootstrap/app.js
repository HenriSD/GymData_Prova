const express = require('express');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const path = require('path');

// Carregar todos os models e associações
require('../app/Models/index');

const app = express();
app.use(express.json());

// Swagger
const swaggerDoc = YAML.load(path.join(__dirname, '../swagger/swagger.yaml'));
app.use('/api-docs', ...swaggerUi.serve, swaggerUi.setup(swaggerDoc));

// Rotas
app.use('/api', require('../routes'));

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok' }));

module.exports = app;
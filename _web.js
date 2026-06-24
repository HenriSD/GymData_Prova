require('dotenv').config();
const app = require('./bootstrap/app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`GymData API rodando na porta ${PORT}`);
});
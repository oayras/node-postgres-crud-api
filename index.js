require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan'); // Middleware para logs de peticiones
const app = express();
const port = 3000;

const db = require('./queries');

// Middleware para loguear las peticiones
app.use(morgan('combined')); // Registra detalles de cada petición

// Middleware para loguear respuestas
app.use((req, res, next) => {
  const originalSend = res.send; // Guarda la función original `res.send`

  res.send = function (body) {
    console.log(`Response for [${req.method}] ${req.originalUrl}:`, body);
    originalSend.call(this, body); // Llama a la función original `res.send` con el cuerpo de la respuesta
  };

  next();
});

app.use(bodyParser.json());
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);

app.get('/', (request, response) => {
  response.json({ info: 'Node.js, Express, and Postgres API' });
});

app.get('/users', db.getUsers);
app.get('/users/:id', db.getUserById);
app.post('/users', db.createUser);
app.put('/users/:id', db.updateUser);
app.delete('/users/:id', db.deleteUser);

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});

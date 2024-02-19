// Configuración de la conexión a la base de datos
const mysql = require("mysql");

const db = mysql.createConnection({
  host: "127.0.0.1",
  port: 3306,
  user: "root",
  password: "wesc",
  database: "PracticalTest",
});

module.exports = { db };

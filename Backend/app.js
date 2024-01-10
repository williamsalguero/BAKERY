const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const secretKey = 'tok3n_d3_prv3v4';
const cors = require('cors');

const app = express();
const port = 3001;

// Configuración de la conexión a la base de datos
const db = mysql.createConnection({
    host: '127.0.0.1',
    port: 3306,
    user: 'william',
    password: 'wesc',
    database: 'PracticalTest',
    authPlugin: 'mysql_native_password',
});

// Configuración de bodyParser para manejar datos JSON
app.use(bodyParser.json());

// Habilitar CORS
app.use(cors());


// Rutas para realizar operaciones CRUD (ejemplo para la tabla Users)
app.post('/api/login', (req, res) => {
    const { email, password } = req.body;

    // Lógica para autenticar al usuario (sustituye esto con tu lógica real)
    db.query('SELECT * FROM Users WHERE email = ? AND password = ?', [email, password], (error, results) => {
        if (error) {
            console.error('Error al autenticar usuario:', error);
            return res.status(500).json({ error: 'Error al autenticar usuario' });
        }

        const user = results[0];
        if (!user) {
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        // Genera el token con el userId y el role
        const token = jwt.sign({ userId: user.id, role: user.role }, secretKey, {
            expiresIn: '1h', // Cambia esto según tus necesidades
        });

        // Devuelve el token al cliente
        res.json({ token });
    });
});

// Middleware de autorización
const authorize = (allowedRoles) => {
    return (req, res, next) => {
        const token = req.headers['x-token'];

        if (!token) {
            return res.status(401).json({ error: 'Token no proporcionado' });
        }

        try {
            const decoded = jwt.verify(token, secretKey);
            const userRole = decoded.role;

            if (allowedRoles.includes(userRole)) {
                req.user = decoded;
                next();
            } else {
                res.status(403).json({ error: 'Acceso prohibido' });
            }
        } catch (error) {
            res.status(401).json({ error: 'Token inválido' });
        }
    };
};

const authorizeUser = authorize(['admin']);

// Rutas para realizar operaciones CRUD (ejemplo para la tabla Users)
app.post('/api/users/create', (req, res) => {
    // Implementa la lógica para crear un usuario utilizando el procedimiento almacenado
    const { name, email, password, role } = req.body;
    db.query('CALL CreateUser(?, ?, ?, ?)', [name, email, password, role], (error, results) => {
        if (error) {
            console.error('Error al crear usuario:', error);
            res.status(500).json({ error: 'Error al crear usuario' });
        } else {
            res.status(201).json({ message: 'Usuario creado con éxito' });
        }
    });
});

app.get('/api/users/read', (req, res) => {
    // Implementa la lógica para obtener todos los usuarios
    db.query('CALL ReadUsers()', (error, results) => {
        if (error) {
            console.error('Error al obtener usuarios:', error);
            res.status(500).json({ error: 'Error al obtener usuarios' });
        } else {
            res.status(200).json(results[0]);
        }
    });
});

app.put('/api/users/update/:id', (req, res) => {
    // Implementa la lógica para actualizar un usuario utilizando el procedimiento almacenado
    const userId = req.params.id;
    const { name, email, password, role } = req.body;
    db.query('CALL UpdateUser(?, ?, ?, ?, ?)', [userId, name, email, password, role], (error, results) => {
        if (error) {
            console.error('Error al actualizar usuario:', error);
            res.status(500).json({ error: 'Error al actualizar usuario' });
        } else {
            res.status(200).json({ message: 'Usuario actualizado con éxito' });
        }
    });
});

app.delete('/api/users/delete/:id',  (req, res) => {
    // Implementa la lógica para eliminar un usuario utilizando el procedimiento almacenado
    const userId = req.params.id;
    db.query('CALL DeleteUser(?)', [userId], (error, results) => {
        if (error) {
            console.error('Error al eliminar usuario:', error);
            res.status(500).json({ error: 'Error al eliminar usuario' });
        } else {
            res.status(200).json({ message: 'Usuario eliminado con éxito' });
        }
    });
});

// Productos, vista de empleados 

app.get('/api/products/read', (req, res) => {
    const sql = 'SELECT * FROM Products';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            res.status(500).json({ error: 'Error al obtener productos' });
        } else {
            res.json(results);
        }
    });
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});

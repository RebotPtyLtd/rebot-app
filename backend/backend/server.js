const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'ilovePGX!',
  database: 'userdb'
});

db.connect(err => {
  if (err) throw err;
  console.log('MySQL connected');
});

app.get('/api/users', (req, res) => {
  db.query('SELECT * FROM users', (err, result) => {
    if (err) return res.status(500).send(err);
    res.json(result);
  });
});

app.post('/api/users', (req, res) => {
  const { name, email } = req.body;
  db.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email], (err) => {
    if (err) return res.status(500).send(err);
    res.send('User added');
  });
});

app.delete('/api/users/:id', (req, res) => {
  db.query('DELETE FROM users WHERE id = ?', [req.params.id], (err) => {
    if (err) return res.status(500).send(err);
    res.send('User deleted');
  });
});

app.put('/api/users/:id', (req, res) => {
  const { name, email } = req.body;
  db.query('UPDATE users SET name = ?, email = ? WHERE id = ?', [name, email, req.params.id], (err) => {
    if (err) return res.status(500).send(err);
    res.send('User updated');
  });
});


app.listen(3001, () => console.log('API server running on port 3001'));

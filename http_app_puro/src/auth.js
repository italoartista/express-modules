const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const users = [
  { id: 1, username: 'admin', password: bcrypt.hashSync('adminpass', 8), roles: ['admin'] },
  { id: 2, username: 'user', password: bcrypt.hashSync('userpass', 8), roles: ['user'] },
];

function authenticateJWT(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) {
    res.writeHead(401, { 'Content-Type': 'text/plain' });
    res.end('Access denied. No token provided.');
    return;
  }

  jwt.verify(token, 'secretKey', (err, user) => {
    if (err) {
      res.writeHead(403, { 'Content-Type': 'text/plain' });
      res.end('Invalid token.');
      return;
    }
    req.user = user;
    next();
  });
}

function authorizeRoles(roles) {
  return (req, res, next) => {
    if (!roles.includes(req.user.roles[0])) {
      res.writeHead(403, { 'Content-Type': 'text/plain' });
      res.end('Access denied.');
      return;
    }
    next();
  };
}

function login(req, res) {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username);
  if (user && bcrypt.compareSync(password, user.password)) {
    const token = jwt.sign({ id: user.id, roles: user.roles }, 'secretKey', { expiresIn: '1h' });
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ token }));
  } else {
    res.writeHead(401, { 'Content-Type': 'text/plain' });
    res.end('Invalid credentials.');
  }
}

module.exports = { authenticateJWT, authorizeRoles, login };

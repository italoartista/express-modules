#!/bin/bash

# Criação da pasta do projeto e navegação para ela
mkdir http_app_puro
cd http_app_puro

# Inicializando o projeto Node.js
npm init -y

# Criação dos diretórios e arquivos necessários
mkdir src
touch src/index.js src/logger.js src/auth.js src/database.js

# Criação do código do servidor básico em Node.js para receber e responder requisições HTTP
cat > src/index.js << 'EOF'
const http = require('http');
const fs = require('fs');
const os = require('os');
const url = require('url');
const { logRequest } = require('./logger');
const { createItem, getItems, getItemById, updateItem, deleteItem } = require('./database');
const { authenticateJWT, authorizeRoles, login } = require('./auth');

const server = http.createServer((req, res) => {
  logRequest(req);

  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname;
  const method = req.method.toUpperCase();

  if (path === '/login' && method === 'POST') {
    let body = '';
    req.on('data', chunk => { body += chunk; });
    req.on('end', () => {
      req.body = JSON.parse(body);
      login(req, res);
    });
  } else if (path.startsWith('/api/items')) {
    if (method === 'GET') {
      if (path === '/api/items') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(getItems()));
      } else {
        const id = path.split('/').pop();
        const item = getItemById(id);
        if (item) {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify(item));
        } else {
          res.writeHead(404, { 'Content-Type': 'text/plain' });
          res.end('Item not found');
        }
      }
    } else if (method === 'POST') {
      authenticateJWT(req, res, () => {
        authorizeRoles(['admin'])(req, res, () => {
          let body = '';
          req.on('data', chunk => { body += chunk; });
          req.on('end', () => {
            req.body = JSON.parse(body);
            const { name } = req.body;
            const item = createItem(name);
            res.writeHead(201, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(item));
          });
        });
      });
    } else if (method === 'PUT') {
      authenticateJWT(req, res, () => {
        authorizeRoles(['admin'])(req, res, () => {
          let body = '';
          req.on('data', chunk => { body += chunk; });
          req.on('end', () => {
            req.body = JSON.parse(body);
            const { name } = req.body;
            const id = path.split('/').pop();
            const item = updateItem(id, name);
            if (item) {
              res.writeHead(200, { 'Content-Type': 'application/json' });
              res.end(JSON.stringify(item));
            } else {
              res.writeHead(404, { 'Content-Type': 'text/plain' });
              res.end('Item not found');
            }
          });
        });
      });
    } else if (method === 'DELETE') {
      authenticateJWT(req, res, () => {
        authorizeRoles(['admin'])(req, res, () => {
          const id = path.split('/').pop();
          if (deleteItem(id)) {
            res.writeHead(204, { 'Content-Type': 'text/plain' });
            res.end();
          } else {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('Item not found');
          }
        });
      });
    } else {
      res.writeHead(405, { 'Content-Type': 'text/plain' });
      res.end('Method Not Allowed');
    }
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

server.listen(3000, () => {
  console.log('Server listening on port 3000');
});
EOF

# Criação do logger.js para logar todas as requisições
cat > src/logger.js << 'EOF'
const fs = require('fs');
const os = require('os');
const path = require('path');

const logFilePath = path.join(os.homedir(), 'http_requests.log');

function logRequest(req) {
  const logEntry = `${new Date().toISOString()} - ${req.method} ${req.url}\n`;
  fs.appendFile(logFilePath, logEntry, (err) => {
    if (err) {
      console.error('Failed to log request:', err);
    }
  });
}

module.exports = { logRequest };
EOF

# Criação de uma API REST básica em Node.js
cat > src/database.js << 'EOF'
let items = [];

function createItem(name) {
  const id = items.length + 1;
  const item = { id, name };
  items.push(item);
  return item;
}

function getItems() {
  return items;
}

function getItemById(id) {
  return items.find(item => item.id === parseInt(id, 10));
}

function updateItem(id, name) {
  const item = getItemById(id);
  if (item) {
    item.name = name;
  }
  return item;
}

function deleteItem(id) {
  const index = items.findIndex(item => item.id === parseInt(id, 10));
  if (index !== -1) {
    items.splice(index, 1);
    return true;
  }
  return false;
}

module.exports = { createItem, getItems, getItemById, updateItem, deleteItem };
EOF

# Criação de middleware de autenticação JWT e autorização
cat > src/auth.js << 'EOF'
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
EOF

# Exibindo instruções finais
echo "Setup complete. Run 'node src/index.js' to start the application."

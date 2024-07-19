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



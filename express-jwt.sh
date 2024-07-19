#!/bin/bash

# Nome do projeto
PROJECT_NAME="auth-api"

# Criar a estrutura de diretórios
mkdir -p $PROJECT_NAME/{controllers,middleware,models,routes,data}
touch $PROJECT_NAME/server.js

# Criar arquivo .env
cat <<EOL > $PROJECT_NAME/.env
JWT_SECRET=your_jwt_secret
EOL

# Criar arquivo package.json
cat <<EOL > $PROJECT_NAME/package.json
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "API with JWT authentication and role-based authorization",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "body-parser": "^1.19.0",
    "dotenv": "^10.0.0",
    "express": "^4.17.1",
    "jsonwebtoken": "^8.5.1",
    "morgan": "^1.10.0"
  },
  "author": "",
  "license": "ISC"
}
EOL

# Criar arquivo server.js
cat <<EOL > $PROJECT_NAME/server.js
require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const bodyParser = require('body-parser');

const userRoutes = require('./routes/user');
const productRoutes = require('./routes/product');

const app = express();

// Middleware
app.use(morgan('dev'));
app.use(bodyParser.json());

// Rotas
app.use('/api/users', userRoutes);
app.use('/api/products', productRoutes);

// Error handling middleware
app.use((req, res, next) => {
  const error = new Error('Not Found');
  error.status = 404;
  next(error);
});

app.use((error, req, res, next) => {
  res.status(error.status || 500);
  res.json({
    error: {
      message: error.message,
    },
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});

module.exports = app;
EOL

# Criar controllers/authController.js
cat <<EOL > $PROJECT_NAME/controllers/authController.js
const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.register = async (req, res) => {
  const { username, password, role } = req.body;

  try {
    const user = { username, password, role };
    await User.addUser(user);
    res.status(201).json({ message: 'User registered successfully' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.login = async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = User.getUserByUsername(username);
    if (!user || !(await User.matchPassword(password, user.password))) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user.username, role: user.role }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });
    res.json({ token });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
EOL

# Criar controllers/productController.js
cat <<EOL > $PROJECT_NAME/controllers/productController.js
const Product = require('../models/Product');

exports.getProducts = async (req, res) => {
  try {
    const products = Product.loadProducts();
    res.json(products);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.createProduct = async (req, res) => {
  const { name, price } = req.body;

  try {
    const product = { name, price };
    Product.addProduct(product);
    res.status(201).json(product);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
EOL

# Criar middleware/auth.js
cat <<EOL > $PROJECT_NAME/middleware/auth.js
const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.protect = (req, res, next) => {
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return res.status(401).json({ message: 'Not authorized, no token' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = User.getUserByUsername(decoded.id);
    next();
  } catch (err) {
    res.status(401).json({ message: 'Not authorized, token failed' });
  }
};

exports.admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({ message: 'Not authorized as an admin' });
  }
};
EOL

# Criar models/User.js
cat <<EOL > $PROJECT_NAME/models/User.js
const fs = require('fs');
const bcrypt = require('bcryptjs');
const usersFilePath = './data/users.json';

const loadUsers = () => {
  if (fs.existsSync(usersFilePath)) {
    const data = fs.readFileSync(usersFilePath, 'utf-8');
    return JSON.parse(data);
  }
  return [];
};

const saveUsers = (users) => {
  fs.writeFileSync(usersFilePath, JSON.stringify(users, null, 2));
};

const getUserByUsername = (username) => {
  const users = loadUsers();
  return users.find(user => user.username === username);
};

const addUser = async (user) => {
  const users = loadUsers();
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  users.push(user);
  saveUsers(users);
};

const matchPassword = async (enteredPassword, storedPassword) => {
  return await bcrypt.compare(enteredPassword, storedPassword);
};

module.exports = {
  loadUsers,
  getUserByUsername,
  addUser,
  matchPassword
};
EOL

# Criar models/Product.js
cat <<EOL > $PROJECT_NAME/models/Product.js
const fs = require('fs');
const productsFilePath = './data/products.json';

const loadProducts = () => {
  if (fs.existsSync(productsFilePath)) {
    const data = fs.readFileSync(productsFilePath, 'utf-8');
    return JSON.parse(data);
  }
  return [];
};

const saveProducts = (products) => {
  fs.writeFileSync(productsFilePath, JSON.stringify(products, null, 2));
};

const addProduct = (product) => {
  const products = loadProducts();
  products.push(product);
  saveProducts(products);
};

module.exports = {
  loadProducts,
  addProduct
};
EOL

# Criar routes/user.js
cat <<EOL > $PROJECT_NAME/routes/user.js
const express = require('express');
const { register, login } = require('../controllers/authController');
const router = express.Router();

router.post('/register', register);
router.post('/login', login);

module.exports = router;
EOL

# Criar routes/product.js
cat <<EOL > $PROJECT_NAME/routes/product.js
const express = require('express');
const { getProducts, createProduct } = require('../controllers/productController');
const { protect, admin } = require('../middleware/auth');
const router = express.Router();

router.get('/', getProducts);
router.post('/', protect, admin, createProduct);

module.exports = router;
EOL

# Criar arquivos de dados iniciais
cat <<EOL > $PROJECT_NAME/data/users.json
[]
EOL

cat <<EOL > $PROJECT_NAME/data/products.json
[]
EOL

# Conclusão
echo "Setup completo. O projeto $PROJECT_NAME foi criado e configurado com sucesso. Execute 'npm install' dentro do diretório $PROJECT_NAME para instalar as dependências."

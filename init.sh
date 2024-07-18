#!/bin/bash

# Nome do projeto
PROJECT_NAME="ecommerce"

# Criar o projeto Express
npx express-generator $PROJECT_NAME
cd $PROJECT_NAME || exit
npm install

# Criar diretórios
mkdir -p src/modules/{user,auth,product,order,review}
mkdir -p src/config
mkdir -p src/middlewares

# Função para criar arquivos
create_file() {
    local file_path=$1
    local content=$2
    echo "$content" > "$file_path"
}

# Criar arquivos para o módulo de usuário
create_file src/modules/user/user.controller.js "
const userService = require('./user.service');

exports.getUsers = async (req, res) => {
  const users = await userService.getAllUsers();
  res.json(users);
};

exports.createUser = async (req, res) => {
  const newUser = await userService.createUser(req.body);
  res.status(201).json(newUser);
};
"

create_file src/modules/user/user.service.js "
const users = []; // Mock database

exports.getAllUsers = async () => {
  return users;
};

exports.createUser = async (user) => {
  users.push(user);
  return user;
};
"

create_file src/modules/user/user.routes.js "
const express = require('express');
const userController = require('./user.controller');

const router = express.Router();

router.get('/', userController.getUsers);
router.post('/', userController.createUser);

module.exports = router;
"

# Repetir para os outros módulos: auth, product, order, review
for module in auth product order review; do
    create_file src/modules/$module/${module}.controller.js "
const ${module}Service = require('./${module}.service');

exports.get${module^}s = async (req, res) => {
  const ${module}s = await ${module}Service.getAll${module^}s();
  res.json(${module}s);
};

exports.create${module^} = async (req, res) => {
  const new${module^} = await ${module}Service.create${module^}(req.body);
  res.status(201).json(new${module^});
};
"
    
    create_file src/modules/$module/${module}.service.js "
const ${module}s = []; // Mock database

exports.getAll${module^}s = async () => {
  return ${module}s;
};

exports.create${module^} = async (${module}) => {
  ${module}s.push(${module});
  return ${module};
};
"
    
    create_file src/modules/$module/${module}.routes.js "
const express = require('express');
const ${module}Controller = require('./${module}.controller');

const router = express.Router();

router.get('/', ${module}Controller.get${module^}s);
router.post('/', ${module}Controller.create${module^});

module.exports = router;
"
done

# Atualizar o arquivo app.js
create_file src/app.js "
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

const userRoutes = require('./modules/user/user.routes');
const authRoutes = require('./modules/auth/auth.routes');
const productRoutes = require('./modules/product/product.routes');
const orderRoutes = require('./modules/order/order.routes');
const reviewRoutes = require('./modules/review/review.routes');

const app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/users', userRoutes);
app.use('/auth', authRoutes);
app.use('/products', productRoutes);
app.use('/orders', orderRoutes);
app.use('/reviews', reviewRoutes);

module.exports = app;
"

# Criar README.md
create_file README.md "
# $PROJECT_NAME

Este projeto é um exemplo de aplicação Express.js modularizada, inspirada na estrutura de módulos do NestJS.

## Estrutura de Diretórios

\`\`\`plaintext
$PROJECT_NAME/
├── src/
│   ├── config/
│   ├── middlewares/
│   ├── modules/
│   │   ├── user/
│   │   │   ├── user.controller.js
│   │   │   ├── user.service.js
│   │   │   └── user.routes.js
│   │   ├── auth/
│   │   │   ├── auth.controller.js
│   │   │   ├── auth.service.js
│   │   │   └── auth.routes.js
│   │   ├── product/
│   │   │   ├── product.controller.js
│   │   │   ├── product.service.js
│   │   │   └── product.routes.js
│   │   ├── order/
│   │   │   ├── order.controller.js
│   │   │   ├── order.service.js
│   │   │   └── order.routes.js
│   │   └── review/
│   │       ├── review.controller.js
│   │       ├── review.service.js
│   │       └── review.routes.js
│   └── app.js
├── bin/
│   └── www
├── package.json
├── public/
├── routes/
│   ├── index.js
│   └── users.js
├── views/
└── ...
\`\`\`

## Configuração e Execução

1. Instale as dependências:
   \`\`\`bash
   npm install
   \`\`\`

2. Execute a aplicação:
   \`\`\`bash
   npm start
   \`\`\`
"

# Conclusão
echo "Setup completo. O projeto $PROJECT_NAME foi criado e configurado com sucesso."

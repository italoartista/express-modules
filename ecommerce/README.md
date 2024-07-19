
# ecommerce

Este projeto é um exemplo de aplicação Express.js modularizada, inspirada na estrutura de módulos do NestJS.

## Estrutura de Diretórios

```plaintext
ecommerce/
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
```

## Configuração e Execução

1. Instale as dependências:
   ```bash
   npm install
   ```

2. Execute a aplicação:
   ```bash
   npm start
   ```



### Testando a API com `curl`

1. **Iniciar o Servidor**

   Primeiro, certifique-se de que o servidor está em execução:

   ```bash
   npm start
   ```

2. **Registrar um Novo Usuário**

   Use o endpoint `/api/users/register` para registrar um novo usuário. Exemplo de comando `curl`:

   ```bash
   curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123","role":"admin"}' http://localhost:3000/api/users/register
   ```

   Se o registro for bem-sucedido, você receberá uma resposta como:

   ```json
   {
     "message": "User registered successfully"
   }
   ```

3. **Fazer Login**

   Use o endpoint `/api/users/login` para fazer login com o usuário registrado. Exemplo de comando `curl`:

   ```bash
   curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}' http://localhost:3000/api/users/login
   ```

   Se o login for bem-sucedido, você receberá um token JWT como resposta:

   ```json
   {
     "token": "your_jwt_token_here"
   }
   ```

4. **Criar um Produto**

   Use o endpoint `/api/products` para criar um novo produto. Esse endpoint requer autenticação e role de admin. Exemplo de comando `curl` (substitua `your_jwt_token_here` pelo token recebido no passo anterior):

   ```bash
   TOKEN="your_jwt_token_here"
   curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"name":"Product1","price":100}' http://localhost:3000/api/products
   ```

   Se a criação do produto for bem-sucedida, você receberá uma resposta como:

   ```json
   {
     "name": "Product1",
     "price": 100
   }
   ```

5. **Listar Produtos**

   Use o endpoint `/api/products` para listar todos os produtos. Esse endpoint não requer autenticação. Exemplo de comando `curl`:

   ```bash
   curl http://localhost:3000/api/products
   ```

   Se houver produtos cadastrados, você receberá uma resposta como:

   ```json
   [
     {
       "name": "Product1",
       "price": 100
     }
   ]
   ```

### Testando a API com Postman

Se preferir usar Postman, siga os passos abaixo:

1. **Iniciar o Servidor**

   Certifique-se de que o servidor está em execução:

   ```bash
   npm start
   ```

2. **Registrar um Novo Usuário**

    - Abra o Postman.
    - Crie uma nova requisição `POST` para `http://localhost:3000/api/users/register`.
    - No corpo da requisição, selecione `raw` e `JSON` e insira o seguinte JSON:

      ```json
      {
        "username": "admin",
        "password": "admin123",
        "role": "admin"
      }
      ```

    - Envie a requisição e verifique a resposta.

3. **Fazer Login**

    - Crie uma nova requisição `POST` para `http://localhost:3000/api/users/login`.
    - No corpo da requisição, selecione `raw` e `JSON` e insira o seguinte JSON:

      ```json
      {
        "username": "admin",
        "password": "admin123"
      }
      ```

    - Envie a requisição e verifique a resposta. Copie o token JWT recebido.

4. **Criar um Produto**

    - Crie uma nova requisição `POST` para `http://localhost:3000/api/products`.
    - No cabeçalho da requisição, adicione um campo `Authorization` com o valor `Bearer your_jwt_token_here`.
    - No corpo da requisição, selecione `raw` e `JSON` e insira o seguinte JSON:

      ```json
      {
        "name": "Product1",
        "price": 100
      }
      ```

    - Envie a requisição e verifique a resposta.

5. **Listar Produtos**

    - Crie uma nova requisição `GET` para `http://localhost:3000/api/products`.
    - Envie a requisição e verifique a resposta.
 
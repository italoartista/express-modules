Claro! Aqui estão exemplos de testes de todas as rotas do sistema de gestão de tarefas usando `curl`. Esses testes assumem que o servidor está rodando localmente na porta padrão (3000) e que você já configurou as rotas conforme descrito no documento de requisitos.

### 1. Criar Tarefa

Para criar uma nova tarefa, você pode usar o comando `curl` para fazer uma solicitação POST para a rota `/api/tarefas`.

```bash
curl -X POST http://localhost:3000/api/tarefas \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Minha nova tarefa",
    "descricao": "Descrição detalhada da tarefa.",
    "status": "pendente"
  }'
```

### 2. Listar Tarefas

Para listar todas as tarefas, você pode usar o comando `curl` para fazer uma solicitação GET para a rota `/api/tarefas`.

```bash
curl -X GET http://localhost:3000/api/tarefas
```

### 3. Atualizar Tarefa

Para atualizar uma tarefa existente, você pode usar o comando `curl` para fazer uma solicitação PUT para a rota `/api/tarefas/:id`, substituindo `:id` pelo ID real da tarefa.

```bash
curl -X PUT http://localhost:3000/api/tarefas/<ID_DA_TAREFA> \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Título atualizado",
    "descricao": "Descrição atualizada.",
    "status": "em andamento"
  }'
```

### 4. Excluir Tarefa

Para excluir uma tarefa existente, você pode usar o comando `curl` para fazer uma solicitação DELETE para a rota `/api/tarefas/:id`, substituindo `:id` pelo ID real da tarefa.

```bash
curl -X DELETE http://localhost:3000/api/tarefas/<ID_DA_TAREFA>
```

### Exemplos Reais

Aqui estão exemplos com IDs fictícios, assumindo que a ID da tarefa a ser atualizada ou excluída é `1234567890abcdef`.

#### Criar Tarefa

```bash
curl -X POST http://localhost:3000/api/tarefas \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Comprar leite",
    "descricao": "Comprar leite na loja do bairro.",
    "status": "pendente"
  }'
```

#### Listar Tarefas

```bash
curl -X GET http://localhost:3000/api/tarefas
```

#### Atualizar Tarefa

```bash
curl -X PUT http://localhost:3000/api/tarefas/1234567890abcdef \
  -H "Content-Type: application/json" \
  -d '{
    "titulo": "Comprar leite e pão",
    "descricao": "Comprar leite e pão na loja do bairro.",
    "status": "em andamento"
  }'
```

#### Excluir Tarefa

```bash
curl -X DELETE http://localhost:3000/api/tarefas/1234567890abcdef
```

### Notas Adicionais

- **Headers**: Certifique-se de definir o cabeçalho `Content-Type: application/json` quando estiver enviando dados JSON nas solicitações POST e PUT.
- **IDs**: Substitua `<ID_DA_TAREFA>` pelos IDs reais das tarefas para as operações de atualização e exclusão.
- **Servidor**: Assegure-se de que o servidor Express.js esteja rodando e escutando na porta configurada (3000 por padrão).

Esses comandos `curl` devem ajudá-lo a testar suas rotas de API manualmente. Se precisar de mais alguma coisa, estou à disposição!
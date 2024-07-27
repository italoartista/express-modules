# Documento de Requisitos - Sistema de Gestão de Tarefas

## Introdução

O Sistema de Gestão de Tarefas tem como objetivo permitir que os usuários criem, leiam, atualizem e excluam tarefas. O sistema deve ser simples e fácil de usar, com uma API RESTful construída utilizando Express.js.

## Requisitos Funcionais# Documento de Requisitos - Sistema de Gestão de Tarefas

## Introdução

O Sistema de Gestão de Tarefas tem como objetivo permitir que os usuários criem, leiam, atualizem e excluam tarefas. Neste estágio, o sistema será implementado com uma abstração de banco de dados, utilizando armazenamento em arquivos para persistência de dados. O backend será desenvolvido com Express.js.

## Requisitos Funcionais

### 1. Cadastro de Tarefas

- **Descrição**: O usuário deve ser capaz de criar uma nova tarefa.
- **Campos**:
  - `id` (string, auto-gerado): Identificador único da tarefa.
  - `titulo` (string, obrigatório): Título da tarefa.
  - `descricao` (string, opcional): Descrição detalhada da tarefa.
  - `status` (string, obrigatório): Status da tarefa (e.g., "pendente", "em andamento", "concluída").
  - `data_criacao` (string, auto-gerado): Data de criação da tarefa.
  - `data_atualizacao` (string, auto-gerado): Data da última atualização da tarefa.

### 2. Visualização de Tarefas

- **Descrição**: O usuário deve ser capaz de visualizar todas as tarefas.
- **Campos Retornados**:
  - `id`
  - `titulo`
  - `descricao`
  - `status`
  - `data_criacao`
  - `data_atualizacao`

### 3. Atualização de Tarefas

- **Descrição**: O usuário deve ser capaz de atualizar os detalhes de uma tarefa existente.
- **Campos Atualizáveis**:
  - `titulo`
  - `descricao`
  - `status`

### 4. Exclusão de Tarefas

- **Descrição**: O usuário deve ser capaz de excluir uma tarefa.
- **Requisitos**: A tarefa deve ser removida permanentemente do sistema.

## Requisitos Não Funcionais

- **Segurança**: O sistema deve ter autenticação básica para proteger a API.
- **Desempenho**: O sistema deve responder a todas as requisições em menos de 200ms.
- **Escalabilidade**: O sistema deve ser capaz de lidar com um número crescente de tarefas e usuários.

## API Endpoints

### 1. Criar Tarefa

- **Método**: `POST`
- **Endpoint**: `/api/tarefas`
- **Corpo da Requisição**:
  ```json
  {
    "titulo": "string",
    "descricao": "string",
    "status": "string"
  }


### 1. Cadastro de Tarefas

- **Descrição**: O usuário deve ser capaz de criar uma nova tarefa.
- **Campos**:
  - `id` (string, auto-gerado): Identificador único da tarefa.
  - `titulo` (string, obrigatório): Título da tarefa.
  - `descricao` (string, opcional): Descrição detalhada da tarefa.
  - `status` (string, obrigatório): Status da tarefa (e.g., "pendente", "em andamento", "concluída").
  - `data_criacao` (string, auto-gerado): Data de criação da tarefa.
  - `data_atualizacao` (string, auto-gerado): Data da última atualização da tarefa.

### 2. Visualização de Tarefas

- **Descrição**: O usuário deve ser capaz de visualizar todas as tarefas.
- **Campos Retornados**:
  - `id`
  - `titulo`
  - `descricao`
  - `status`
  - `data_criacao`
  - `data_atualizacao`

### 3. Atualização de Tarefas

- **Descrição**: O usuário deve ser capaz de atualizar os detalhes de uma tarefa existente.
- **Campos Atualizáveis**:
  - `titulo`
  - `descricao`
  - `status`

### 4. Exclusão de Tarefas

- **Descrição**: O usuário deve ser capaz de excluir uma tarefa.
- **Requisitos**: A tarefa deve ser removida permanentemente do sistema.

## Requisitos Não Funcionais

- **Segurança**: O sistema deve ter autenticação básica para proteger a API.
- **Desempenho**: O sistema deve responder a todas as requisições em menos de 200ms.
- **Escalabilidade**: O sistema deve ser capaz de lidar com um número crescente de tarefas e usuários.

## API Endpoints

### 1. Criar Tarefa

- **Método**: `POST`
- **Endpoint**: `/api/tarefas`
- **Corpo da Requisição**:
  ```json
  {
    "titulo": "string",
    "descricao": "string",
    "status": "string"
  }

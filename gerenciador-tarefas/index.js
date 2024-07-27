/* 
    * Arquivo: index.js

    * Aplicação: Gerenciador de Tarefas


*/

const express = require('express'); 
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

/* 
{ 
  "id": "1", 
  "nome": "Estudar Node",
  "descricao": "Ler todas a doc",
  "status": "Em andamento"
}

*/


const tarefas = [
    { 
        id: '1',
        nome: 'Estudar Node',
        descricao: 'Ler todas a doc',
        status: 'Em andamento'
    },
    {
        id: '2',
        nome: 'Estudar React',
        descricao: 'Fazer o curso de React',
        status: 'Em andamento'
    },
    {
        id: '3',
        nome: 'Estudar Angular',
        descricao: 'Fazer o curso de Angular',
        status: 'Em andamento'
    },
    {
        id: '4',
        nome: 'Estudar Java',
        descricao: 'Fazer o curso de Java',
        status: 'Em andamento'
    },
    {
        id: '5',
        nome: 'Estudar Python',
        descricao: 'Fazer o curso de Python',
        status: 'Em andamento'
    }
];


app.get('/tarefas', (req, res) => {
    res.json(tarefas);
})

app.post('/tarefas', (req, res) => {
    // Get the request body
    const tarefa = req.body;


    // Log the request body for debugging
    console.log('Request body:', tarefa);

    // Validate the request body
    if (!tarefa || typeof tarefa !== 'object') {
        console.error('Invalid tarefa data:', tarefa);
        return res.status(400).json({ error: 'Invalid tarefa data' });
    }

    console.log('Valid tarefa:', tarefa);
    tarefas.push(tarefa);
    res.status(201).json(tarefa);
});


app.put('/tarefas/:id', (req, res) => { 
    const id = req.params.id;
    const tarefa = req.body;

    if (!tarefa || typeof tarefa !== 'object') {
        console.error('Invalid tarefa data:', tarefa);
        return res.status(400).json({ error: 'Invalid tarefa data' });
    }

    const index = tarefas.findIndex(t => t.id === id);
    if (index < 0) {
        return res.status(404).json({ error: 'Tarefa not found' });
    }

    tarefas[index] = tarefa;

    res.json(tarefa);
});

app.delete('/tarefas/:id', (req, res) => {
    const id = req.params.id;

    const index = tarefas.findIndex(t => t.id === id);
    if (index < 0) {
        return res.status(404).json({ error: 'Tarefa not found' });
    }

    tarefas.splice(index, 2);

    res.status(204).end();
});

const port = 3000;



app.listen(port, () => { 
    console.log(`Example app listening at http://localhost:${port}`);
})
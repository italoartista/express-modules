const express = require('express');
const router = express.Router();

const users = [];

// GET users
router.get('/', (req, res) => {
    res.json(users);
});

// POST users
router.post('/', (req, res) => {
    const { username, password } = req.body;
    const user = { username, password };
    users.push(user);
    res.status(201).json(user);
});

// PUT users
router.put('/:username', (req, res) => {
    const username = req.params.username;
    const { password } = req.body;

    const user = users.find(u => u.username === username);
    if (user) {
        user.password = password;
        res.json(user);
    } else {
        res.status(404).json({ message: 'User not found' });
    }
});

module.exports = router;

const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const http = require('http');

// Mock Databases
const users = [];
const products = [];
const orders = [];
const reviews = [];

// Controllers
const userController = {
    getUsers: async (req, res) => {
        res.json(users);
    },
    createUser: async (req, res) => {
        users.push(req.body);
        res.status(201).json(req.body);
    }
};

const authController = {
    login: async (req, res) => {
        const user = users.find(u => u.username === req.body.username && u.password === req.body.password);
        if (user) {
            res.json({ message: 'Login successful' });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    },
    register: async (req, res) => {
        users.push(req.body);
        res.status(201).json(req.body);
    }
};

const productController = {
    getProducts: async (req, res) => {
        res.json(products);
    },
    createProduct: async (req, res) => {
        products.push(req.body);
        res.status(201).json(req.body);
    }
};

const orderController = {
    getOrders: async (req, res) => {
        res.json(orders);
    },
    createOrder: async (req, res) => {
        orders.push(req.body);
        res.status(201).json(req.body);
    }
};

const reviewController = {
    getReviews: async (req, res) => {
        res.json(reviews);
    },
    createReview: async (req, res) => {
        reviews.push(req.body);
        res.status(201).json(req.body);
    }
};

// Routes
const userRoutes = express.Router();
userRoutes.get('/', userController.getUsers);
userRoutes.post('/', userController.createUser);

const authRoutes = express.Router();
authRoutes.post('/login', authController.login);
authRoutes.post('/register', authController.register);

const productRoutes = express.Router();
productRoutes.get('/', productController.getProducts);
productRoutes.post('/', productController.createProduct);

const orderRoutes = express.Router();
orderRoutes.get('/', orderController.getOrders);
orderRoutes.post('/', orderController.createOrder);

const reviewRoutes = express.Router();
reviewRoutes.get('/', reviewController.getReviews);
reviewRoutes.post('/', reviewController.createReview);

// Create Express app
const app = express();

// Middleware setup
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Routes setup
app.use('/users', userRoutes);
app.use('/auth', authRoutes);
app.use('/products', productRoutes);
app.use('/orders', orderRoutes);
app.use('/reviews', reviewRoutes);

// Get port from environment and store in Express.
const port = normalizePort(process.env.PORT || '3000');
app.set('port', port);

// Create HTTP server.
const server = http.createServer(app);

// Listen on provided port, on all network interfaces.
server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

// Normalize a port into a number, string, or false.
function normalizePort(val) {
    const port = parseInt(val, 10);

    if (isNaN(port)) {
        // named pipe
        return val;
    }

    if (port >= 0) {
        // port number
        return port;
    }

    return false;
}

// Event listener for HTTP server "error" event.
function onError(error) {
    if (error.syscall !== 'listen') {
        throw error;
    }

    const bind = typeof port === 'string'
        ? 'Pipe ' + port
        : 'Port ' + port;

    // handle specific listen errors with friendly messages
    switch (error.code) {
        case 'EACCES':
            console.error(bind + ' requires elevated privileges');
            process.exit(1);
            break;
        case 'EADDRINUSE':
            console.error(bind + ' is already in use');
            process.exit(1);
            break;
        default:
            throw error;
    }
}

// Event listener for HTTP server "listening" event.
function onListening() {
    const addr = server.address();
    const bind = typeof addr === 'string'
        ? 'pipe ' + addr
        : 'port ' + addr.port;
    console.log('Listening on ' + bind);
}

module.exports = app;

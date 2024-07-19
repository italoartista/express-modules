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

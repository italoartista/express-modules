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

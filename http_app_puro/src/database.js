let items = [];

function createItem(name) {
  const id = items.length + 1;
  const item = { id, name };
  items.push(item);
  return item;
}

function getItems() {
  return items;
}

function getItemById(id) {
  return items.find(item => item.id === parseInt(id, 10));
}

function updateItem(id, name) {
  const item = getItemById(id);
  if (item) {
    item.name = name;
  }
  return item;
}

function deleteItem(id) {
  const index = items.findIndex(item => item.id === parseInt(id, 10));
  if (index !== -1) {
    items.splice(index, 1);
    return true;
  }
  return false;
}

module.exports = { createItem, getItems, getItemById, updateItem, deleteItem };

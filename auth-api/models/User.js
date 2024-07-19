const fs = require('fs');
const bcrypt = require('bcryptjs');
const usersFilePath = './data/users.json';

const loadUsers = () => {
  if (fs.existsSync(usersFilePath)) {
    const data = fs.readFileSync(usersFilePath, 'utf-8');
    return JSON.parse(data);
  }
  return [];
};

const saveUsers = (users) => {
  fs.writeFileSync(usersFilePath, JSON.stringify(users, null, 2));
};

const getUserByUsername = (username) => {
  const users = loadUsers();
  return users.find(user => user.username === username);
};

const addUser = async (user) => {
  const users = loadUsers();
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  users.push(user);
  saveUsers(users);
};

const matchPassword = async (enteredPassword, storedPassword) => {
  return await bcrypt.compare(enteredPassword, storedPassword);
};

module.exports = {
  loadUsers,
  getUserByUsername,
  addUser,
  matchPassword
};

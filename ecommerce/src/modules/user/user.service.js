
const users = []; // Mock database

exports.getAllUsers = async () => {
  return users;
};

exports.createUser = async (user) => {
  users.push(user);
  return user;
};


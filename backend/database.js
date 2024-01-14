const Sequelize = require("sequelize");

const DB_HOST = process.env.DB_HOST;
const DB_PORT = process.env.DB_PORT;
const DB_PASSWORD = process.env.DB_PASSWORD;
const DB_DATABASE = process.env.DB_DATABASE;

const db = new Sequelize(DB_DATABASE,'root',DB_PASSWORD,{
    host: DB_HOST,
    dialect: 'mysql'
});

module.exports = db;
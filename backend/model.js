const Sequelize = require("sequelize");
const db = require('./database');

const data = db.define("data_table",{
    id:{
        type: Sequelize.INTEGER,
        primaryKey: true,
        allowNull: false
    },
    data: {
        type: Sequelize.STRING,
        allowNull: false
    }
},{});

module.exports = data;
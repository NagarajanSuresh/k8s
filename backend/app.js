const express = require('express');
const Sequelize = require("sequelize");
const body_parser = require('body-parser');

const DB_HOST = process.env.DB_HOST;
const DB_PORT = process.env.DB_PORT;
const DB_PASSWORD = process.env.DB_PASSWORD;
const DB_DATABASE = process.env.DB_DATABASE;

console.log(`INFO: DB host from environment variable: ${DB_HOST}`);
console.log(`INFO: DB port from environment variable: ${DB_PORT}`);
console.log(`INFO: DB password from environment variable: ${DB_PASSWORD}`);
console.log(`INFO: DB database name from environment variable: ${DB_DATABASE}`);

const db = new Sequelize(DB_DATABASE,'root',DB_PASSWORD,{
    host: DB_HOST,
    dialect: 'mysql'
});


// const db_connection = mysql.createConnection({
//     host: DB_HOST,
//     user: 'root2',
//     password: DB_PASSWORD,
//     database: DB_DATABASE,
//     port: DB_PORT
// })

const app = express();
app.use(body_parser.json({extended:false}))

const port = process.env.PORT;
console.log(`INFO: port from environment variable: ${port}`);

app.get('/get',(req,res) => {
    res.status(200).json({
        message: "Get request successful!"
    })
})

app.post('/post',(req,res) => {
    console.log(req.body);
    res.status(200).json({
        message: "Post request successful!"
    })
})
app.listen(port,async() => {
    try {
        await db.authenticate();
        console.log("INFO: DB connection successful!");
        console.log(`INFO: Server started listening at port ${port}`);
    } catch (error) {
        console.error('ERROR: DB connection failed. ' + err.stack);
    }
});
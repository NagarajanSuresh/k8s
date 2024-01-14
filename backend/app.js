const express = require('express');
const body_parser = require('body-parser');
const sequelize = require('sequelize');

const db = require('./database');

const data_model = require('./model');

const app = express();
app.use(body_parser.json({extended:false}))

const port = process.env.PORT;
console.log(`INFO: port from environment variable: ${port}`);



app.get('/get',async(req,res) => {
    try {
        const data = await data_model.findAll();
        return res.status(200).json({
            message: "Get request successful!",
            data: data
        })
    } catch (error) {
        console.log("ERROR: Get request failed.");
        console.log(error);
        return res.status(404).json({
            message: "Get request failed!",
            data: error.message
        })
    }
})

app.post('/post',async(req,res) => {
    const data = req.body.message;
    if(data === undefined){
        return res.status(404).json({
            message: "Post request failed!",
            data: "Message is not sent via body!"
        })
    }

    try {
        const id = (await data_model.findAll()).length + 1;
        const new_data = await data_model.create({
            data: data,
            id: id
        });
        return res.status(200).json({
            message: "Post request successful!",
            data: new_data
        })
    } catch (error) {
        console.log("ERROR: Post request failed.");
        console.log(error);
        return res.status(404).json({
            message: "Post request failed!",
            data: error.message
        })
    }
})
app.listen(port,async() => {
    try {
        await db.authenticate();
        //Creates the table if not exist
        await db.sync();
        await data_model.destroy({
            where: {},
            truncate: true
        })
        console.log("INFO: DB connection successful!");
        console.log(`INFO: Server started listening at port ${port}`);
    } catch (error) {
        console.error('ERROR: DB connection failed. ' + error.stack);
    }
});
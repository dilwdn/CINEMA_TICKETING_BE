const {Client} = require('pg')
require('dotenv').config();

const config = process.env;
console.log(config.PG_HOST);

const client = new Client({
    host: config.PG_HOST,
    user: config.PG_USER,
    port: config.PG_PORT,
    password: config.PG_PASSWORD,
    database: config.PG_DATABASE,
})

module.exports = client;

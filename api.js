const express = require('express')
const bodyParser = require('body-parser')

const client = require('./connection')
const app = express()

app.use(bodyParser.json())

app.listen(3100, ()=> {
    console.log('Server running in port 3100')
})

client.connect(err => {
    if(err){
        console.log(err.message)
    } else {
        console.log('Connected')
    }
})

app.get('/bioskop', (req, res) => {
    client.query('Select * from bioskop', (err, result) => {
        if(!err){
            res.send(result.rows)
        }
    })
})
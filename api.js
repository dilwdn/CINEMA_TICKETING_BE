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
            res.send(result)
        }
    })
})

app.get('/film-yang-sedang-tayang', (req, res) => {
    client.query("SELECT * FROM film WHERE f_status = 'Sedang Tayang'", (err, result) => {
        if (!err) {
            res.send(result)
        }
    })
})

app.get('/film-yang-akan-tayang', (req, res) => {
    client.query("SELECT * FROM film WHERE f_status = 'Segera Tayang'", (err, result) => {
        if(!err){
            res.send(result)
        }
    })
})

app.get('/Film-jadwalnya-kapan-dimana-aja', (req, res) => {
    client.query("SELECT f.f_judul, j.j_waktu, b.b_nama, b.b_kota, b.b_alamat FROM jadwal j JOIN sesi_pemutaran sp ON j.j_id_jadwal = sp.ss_id_jadwal JOIN film f ON sp.ss_id_film = f.f_id_film JOIN studio s ON sp.ss_id_studio = s.s_id_studio JOIN bioskop b ON s.s_id_bioskop = b.b_id_bioskop", (err, result) => {
        if(!err){
            res.send(result)
        }
    })
})

app.get('/kursi-berdasarkan-id-jadwal', (req, res) => {
    client.query("SELECT j.j_id_jadwal, j.j_waktu, k.k_id_kursi, k.k_nama, k.k_status FROM kursi k JOIN sesi_pemutaran sp ON k.k_id_sesi_pemutaran = sp.ss_id_sesi_pemutaran JOIN jadwal j ON sp.ss_id_jadwal = j.j_id_jadwal WHERE j.j_id_jadwal = ss_id_jadwal", (err, result) => {
        if(!err){
            res.send(result)
        }
    })
})

app.get('/transaksi-berdasarkan-id-customer', (req, res) => {
    client.query("SELECT t_id_customer, t_id_transaksi, t_waktu, t_total_harga, t_status, t_metode_pembayaran FROM transaksi ORDER BY t_id_customer", (err, result) => {
        if(!err){
            res.send(result)
        }
    })
})

app.post('/pendaftaran-user-baru', (req, res) => {
    const {c_nama, c_jenis_kelamin, c_nomor_telpon, c_alamat, c_email} = req.body

    client.query(`insert into customer(c_nama, c_jenis_kelamin, c_nomor_telpon, c_alamat, c_email) values('${c_nama}', '${c_jenis_kelamin}', '${c_nomor_telpon}', '${c_alamat}', '${c_email}')`), (err, result) => {
        if(!err){
            res.send('Insert Success')
        } else{
            res.send(err, message)
        }
    }
})

app.post('/transaksi-baru', (req, res) => {
    const {t_waktu, t_total_harga, t_status, t_metode_pembayaran, t_id_customer} = req.body

    client.query(`insert into transaksi(t_waktu, t_total_harga, t_status, t_metode_pembayaran, ) values('${t_waktu}', '${t_total_harga}', '${t_status}', '${t_metode_pembayaran}', '${t_id_customer}')`), (err, result) => {
        if(!err){
            res.send('Insert Success')
        } else{
            res.send(err, message)
        }
    }
})

app.put('/update-nomor-telepon/:id', (req, res) => {
    const {c_nomor_telepon} = req.body
    client.query((`update customer set c_nomor_telepon = '${c_nomor_telepon}'`), (err, result) => {
        if(!err){
            res.send('Update Success')
        } else {
            res.send(err.message)
        }
    })
})

app.put('/update-email/:id', (req, res) => {
    const {c_email} = req.body
    client.query((`update customer set c_email = '${c_email}'`), (err, result) => {
        if(!err){
            res.send('Update Success')
        } else {
            res.send(err.message)
        }
    })
})

app.put('/update-alamat/:id', (req, res) => {
    const {c_alamat} = req.body
    client.query((`update customer set c_alamat = '${c_alamat}'`), (err, result) => {
        if(!err){
            res.send('Update Success')
        } else {
            res.send(err.message)
        }
    })
})

app.put('/update-status-kursi/:id', (req, res) => {
    const {k_status} = req.body
    client.query((`update customer set k_status = '${k_status}'`), (err, result) => {
        if(!err){
            res.send('Update Success')
        } else {
            res.send(err.message)
        }
    })
})
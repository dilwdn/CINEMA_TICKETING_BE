const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors');

const client = require('./connection')
const app = express()

app.use(bodyParser.json())
app.use(cors());

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

app.get('/allmovies', (req, res) => {
    client.query('Select * from film', (err, result) => {
        if(!err){
            res.send(result)
        }
    })
})

app.get('/allsesipemutaran', (req, res) => {
    client.query('Select * from sesi_pemutaran', (err, result) => {
        if(!err){
            res.send(result)
        }
    })
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
    const k_id_sesi_pemutaran = req.query.k_id_sesi_pemutaran;

    const query = `
        SELECT *
        FROM kursi
        WHERE k_id_sesi_pemutaran = $1
    `;
    const values = [k_id_sesi_pemutaran];
    client.query(query, values, (err, result) => {
        if(!err){
            res.send(result.rows)
        } else {
            console.error(err);
            res.status(500).send('Error retrieving kursi by k_id_sesi_pemutaran');
        }
    });
})

app.get('/jadwalbyid', (req, res) => {
    const j_id_jadwal = req.query.j_id_jadwal;

    const query = `
        SELECT *
        FROM jadwal
        WHERE j_id_jadwal = $1
    `;
    const values = [j_id_jadwal];
    client.query(query, values, (err, result) => {
        if(!err){
            res.send(result.rows)
        } else {
            console.error(err);
            res.status(500).send('Error retrieving kursi by k_id_sesi_pemutaran');
        }
    });
})

app.get('/sesipemutaranbyid', (req, res) => {
    const ss_id_film = req.query.ss_id_film;
  
    const query = `
    SELECT *
      FROM sesi_pemutaran
      JOIN jadwal ON sesi_pemutaran.ss_id_jadwal = jadwal.j_id_jadwal
      JOIN studio ON sesi_pemutaran.ss_id_studio = studio.s_id_studio
      JOIN bioskop ON studio.s_id_bioskop = bioskop.b_id_bioskop
      WHERE ss_id_film = $1`;
    const values = [ss_id_film];
  
    client.query(query, values, (err, result) => {
      if (!err) {
        res.send(result.rows);
      } else {
        console.error(err);
        res.status(500).send('Error retrieving sesi_pemutaran by ss_id_film');
      }
    });
  });

app.get('/carifilm', (req, res) => {
    console.log(req.query)
    const f_judul = req.query.f_judul;

    const query = `
    SELECT *
    FROM film
    WHERE f_judul ILIKE $1`;
    const values = [`%${f_judul}%`];

    client.query(query, values, (err, result) => {
        if(!err){
            res.send(result.rows);
        } else {
            console.error(err);
            res.status(500).send('Error retrieving film by f_judul');
        }
    });
});

app.get('/detailtiket', (req, res) => {
    const c_id = req.query.c_id;

    const query = `
    SELECT *
    FROM customer JOIN transaksi ON customer.c_id = transaksi.t_id_customer
    JOIN sesi_pemutaran ON sesi_pemutaran.ss_id_sesi_pemutaran = transaksi.t_id_sesi_pemutaran
    JOIN jadwal ON jadwal.j_id_jadwal = sesi_pemutaran.ss_id_jadwal
    JOIN film ON film.f_id_film = sesi_pemutaran.ss_id_film
    JOIN studio ON studio.s_id_studio = sesi_pemutaran.ss_id_studio
    WHERE customer.c_id = $1`;
    const values = [c_id];

    client.query(query, values, (err, result) => {
        if(!err){
            res.send(result.rows);
        } else {
            console.error(err);
            res.status(500).send('Error retrieving transaksi by id_pemesanan');
        }
    });
});

app.get('/signin', (req, res) => {
    console.log(req.query);
const c_nama = req.query.c_nama;
const c_email = req.query.c_email;

const query = `
    SELECT *
    FROM customer
    WHERE c_nama = $1 
    AND c_email = $2
`;
const values = [c_nama, c_email];

client.query(query, values, (err, result) => {
    if (!err) {
        res.send(result.rows);
    } else {
        console.error(err);
        res.status(500).send('Error retrieving sesi_pemutaran by ss_id_film');
    }
});
});

app.get('/transaksi-berdasarkan-id-customer', (req, res) => {
    const t_id_customer = req.query.t_id_customer;

    const query = `
        SELECT *
        FROM transaksi
        WHERE t_id_customer = $1
    `;
    const values = [t_id_customer];
    client.query(query, values, (err, result) => {
        if(!err){
            res.send(result.rows)
        } else {
            console.error(err);
            res.status(500).send('Error retrieving kursi by k_id_sesi_pemutaran');
        }
    });
})

app.post('/pendaftaran-user-baru', (req, res) => {
    console.log(req.body);
    const {c_nama, c_jenis_kelamin, c_nomor_telepon, c_alamat, c_email} = req.body;

    client.query(`insert into customer(c_nama, c_jenis_kelamin, c_nomor_telepon, c_alamat, c_email) values('${c_nama}', '${c_jenis_kelamin}', '${c_nomor_telepon}', '${c_alamat}', '${c_email}')`), (err, result) => {
        if(!err){
            res.send('Insert Success')
        } else{
            res.send(err, message)
        }
    }
})

app.post('/transaksi-baru', (req, res) => {
    const { t_waktu, t_total_harga, t_status, t_metode_pembayaran, t_id_customer, t_id_sesi_pemutaran } = req.body;

    client.query(`INSERT INTO transaksi(t_waktu, t_total_harga, t_status, t_metode_pembayaran, t_id_customer, t_id_sesi_pemutaran) VALUES('${t_waktu}', '${t_total_harga}', '${t_status}', '${t_metode_pembayaran}', '${t_id_customer}', '${t_id_sesi_pemutaran}') RETURNING t_id_transaksi`, (err, result) => {
        if (!err) {
            const insertedRow = result.rows[0];
            res.send({ success: true, insertedRow });
        } else {
            res.send({ success: false, error: err.message });
        }
    });
});


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

app.put('/updatekursi/:id', (req, res) => {
    const { t_id_transaksi } = req.body;
    client.query(
        `UPDATE kursi SET k_id_transaksi = '${t_id_transaksi}', k_status = 'Terisi' WHERE k_id_kursi = ${req.params.id}`,
        (err, result) => {
            if (!err) {
                res.send('Update Success');
            } else {
                res.send(err.message);
            }
        }
    );
});

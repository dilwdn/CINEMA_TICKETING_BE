-- create tables for cinema ticketing database
-- types for enum
CREATE TYPE jenis_kelamin AS ENUM ('L','P');
CREATE TYPE rating AS ENUM ('G','PG','PG-13','R', 'NC-13');
CREATE TYPE status_tayang AS ENUM ('Segera Tayang','Sedang Tayang','Selesai Tayang');
CREATE TYPE status_kursi AS ENUM ('Kosong','Terisi');
CREATE TYPE status_pembayaran AS ENUM ('Menunggu Pembayaran','Berhasil');
CREATE TYPE metode_pembayaran AS ENUM ('Transfer Bank','Ovo','Gopay', 'Dana');

-- configure sequence
CREATE SEQUENCE IF NOT EXISTS id_sequence
    AS INT
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 1000
    START WITH 1
    CACHE 10
    NO CYCLE;

-- customer
CREATE TABLE customer (
    c_id INT NOT NULL DEFAULT nextval('id_sequence'),
    c_nama VARCHAR(30) NOT NULL,
    c_jenis_kelamin jenis_kelamin NOT NULL,
    c_nomor_telepon VARCHAR(15) NOT NULL,
    c_alamat VARCHAR(50) NOT NULL,
    c_email VARCHAR(30) NOT NULL
);

-- bioskop
CREATE TABLE bioskop (
    b_id_bioskop INT NOT NULL,
    b_nama VARCHAR(30) NOT NULL,
    b_kota VARCHAR(30) NOT NULL,
    b_alamat VARCHAR(255) NOT NULL,
    b_kontak VARCHAR(15) NOT NULL
);

-- studio
CREATE TABLE studio (
    s_id_studio INT NOT NULL,
    s_nama VARCHAR(30) NOT NULL,
    s_id_bioskop INT NOT NULL
);

-- film
CREATE TABLE film (
    f_id_film INT NOT NULL,
    f_judul VARCHAR(30) NOT NULL,
    f_rating rating NOT NULL,
    f_durasi INT NOT NULL,
    f_genre VARCHAR(30) NOT NULL,
    f_sutradara VARCHAR(30) NOT NULL,
    f_url_poster VARCHAR(255) NOT NULL,
    f_url_trailer VARCHAR(255) NOT NULL,
    f_status status_tayang NOT NULL
);

-- jadwal
CREATE TABLE jadwal (
    j_id_jadwal INT NOT NULL,
    j_waktu TIMESTAMP NOT NULL,
    j_harga INT NOT NULL
);

-- sesi pemutaran
CREATE TABLE sesi_pemutaran (
    ss_id_sesi_pemutaran INT NOT NULL,
    ss_id_jadwal INT NOT NULL,
    ss_id_studio INT NOT NULL,
    ss_id_film INT NOT NULL
);

-- kursi
CREATE TABLE kursi (
    k_id_kursi INT NOT NULL,
    k_nama VARCHAR(5),
    k_status status_kursi NOT NULL,
    k_id_sesi_pemutaran INT NOT NULL,
    k_id_transaksi INT
);

-- transaksi
CREATE TABLE transaksi (
    t_id_transaksi INT NOT NULL DEFAULT nextval('id_sequence'),
    t_waktu TIMESTAMP NOT NULL,
    t_total_harga INT NOT NULL,
    t_status status_pembayaran NOT NULL,
    t_metode_pembayaran metode_pembayaran NOT NULL,
    t_id_customer INT NOT NULL,
	t_id_sesi_pemutaran INT NOT NULL
);

-- primary keys
ALTER TABLE customer ADD PRIMARY KEY (c_id);
ALTER TABLE bioskop ADD PRIMARY KEY (b_id_bioskop);
ALTER TABLE studio ADD PRIMARY KEY (s_id_studio);
ALTER TABLE film ADD PRIMARY KEY (f_id_film);
ALTER TABLE jadwal ADD PRIMARY KEY (j_id_jadwal);
ALTER TABLE sesi_pemutaran ADD PRIMARY KEY (ss_id_sesi_pemutaran);
ALTER TABLE kursi ADD PRIMARY KEY (k_id_kursi);
ALTER TABLE transaksi ADD PRIMARY KEY (t_id_transaksi);

-- foreign keys
ALTER TABLE studio ADD FOREIGN KEY (s_id_bioskop) REFERENCES bioskop(b_id_bioskop);
ALTER TABLE sesi_pemutaran ADD FOREIGN KEY (ss_id_jadwal) REFERENCES jadwal(j_id_jadwal);
ALTER TABLE sesi_pemutaran ADD FOREIGN KEY (ss_id_studio) REFERENCES studio(s_id_studio);
ALTER TABLE sesi_pemutaran ADD FOREIGN KEY (ss_id_film) REFERENCES film(f_id_film);
ALTER TABLE kursi ADD FOREIGN KEY (k_id_sesi_pemutaran) REFERENCES sesi_pemutaran(ss_id_sesi_pemutaran);
ALTER TABLE kursi ADD FOREIGN KEY (k_id_transaksi) REFERENCES transaksi(t_id_transaksi);
ALTER TABLE transaksi ADD FOREIGN KEY (t_id_sesi_pemutaran) REFERENCES sesi_pemutaran(ss_id_sesi_pemutaran);
ALTER TABLE transaksi ADD FOREIGN KEY (t_id_customer) REFERENCES customer(c_id);

INSERT INTO customer (c_nama, c_jenis_kelamin, c_nomor_telepon, c_alamat, c_email)
VALUES 
  ('Budi Santoso', 'L', '081234567890', 'Jl. Merdeka No. 123, Jakarta', 'busan77@gmail.com'),
  ('Sinta Laila', 'P', '082345678901', 'Jl. Raya Kedungsoko No.154, Tulungagung', 'laila@gmail.com'),
  ('Irfan Bachdim', 'L', '083456789012', 'Jl. Kemuning No. 67, Surabaya', 'irfaan99@gmail.com'),
  ('Laura Indah', 'P', '084567890123', 'Jl. Gebang Lor NO.38, Surabaya', 'lauxixi@gmail.com'),
  ('David Wilson', 'L', '085678901234', 'Jl. Cendana No. 101, Makassar', 'davidwilson@gmail.com');
  
INSERT INTO bioskop (b_id_bioskop, b_nama, b_kota, b_alamat, b_kontak)
VALUES
    (1, 'Pesona Square XXI', 'Jakarta', 'Jl. Ir. H. Juanda No. 99', '02177817177'),
    (2, 'Golden Theater', 'Tulungagung', 'Jl. Ahmad Yani Timur No. 66', '0355335640'),
    (3, 'Delta XXI', 'Surabaya', 'Jl. Pemuda No. 31-37', '0315311668'),
    (4, 'Galaxi XXI', 'Surabaya', 'Jl. Soekarno No. 35 Mulyosari', '0315937121'),
    (5, 'MTos XXI', 'Makassar', 'Jl. Perintis Kemerdekaan No. 7', '0411583321'),
	(6, 'Pakuwon City XXI', 'Surabaya', 'Jl. Raya Laguna Kejawen Putih No. 17', '03158208821'),
	(7, 'Movie Theater XXI', 'Makassar', 'Jl. Pengayoman Kec. Panakkukang','0411424158' );

INSERT INTO studio (s_id_studio, s_nama, s_id_bioskop)
VALUES
    (1, 'Theater 1', 1),
    (2, 'Theater 2', 1),
    (3, 'Theater 3', 1),
    (4, 'Theater 1', 2),
    (5, 'Theater 2', 2),
	(6, 'Theater 3', 2),
	(7, 'Theater 1', 3),
    (8, 'Theater 2', 3),
	(9, 'Theater 3', 3),
	(10, 'Theater 4', 3),
    (11, 'Theater 1', 4),
	(12, 'Theater 2', 4),
	(13, 'Theater 1', 5),
    (14, 'Theater 2', 5),
	(15, 'Theater 3', 5),
	(16, 'Theater 1', 6),
    (17, 'Theater 2', 6),
	(18, 'Theater 3', 6),
	(19, 'Theater 1', 7),
    (20, 'Theater 2', 7),
	(21, 'Theater 3', 7);

INSERT INTO film (f_id_film, f_judul, f_rating, f_durasi, f_genre, f_sutradara, f_url_poster, f_url_trailer, f_status)
VALUES
    (1, 'Hypnotic', 'R', 93, 'Action', 'Robert Rodriguez', 'https://www.joblo.com/wp-content/uploads/2023/04/Hypnotic-poster-1-691x1024.jpg', 'https://www.youtube.com/embed/eHsWYmnXk1o', 'Segera Tayang'),
    (2, 'Hello Ghost', 'PG-13', 114, 'Comedy', 'Indra Gunawan', 'https://awsimages.detik.net.id/community/media/visual/2023/04/12/hello-ghost_34.jpeg?w=600&q=90', 'https://www.youtube.com/embed/ICoxxRSFFgs', 'Sedang Tayang'),
    (3, 'Hati Suhita', 'PG-13', 137, 'Drama', 'Archie Hekagery', 'https://m.media-amazon.com/images/M/MV5BMjg0ZTM1MTgtNmM4OC00OGEzLWEyNGMtYTI4NjI3Yjg3MmQwXkEyXkFqcGdeQXVyMTEzMTI1Mjk3._V1_.jpg', 'https://www.youtube.com/embed/elIcNsHm6pM', 'Sedang Tayang'),
    (4, 'The Little Mermaid', 'G', 135, 'Adventure, Fantasy', 'Dvid Magee', 'https://deadline.com/wp-content/uploads/2023/04/FupVaRaWwAAe7tw.jpg?w=800', 'https://www.youtube.com/embed/kpGo2_d3oYE', 'Sedang Tayang'),
    (5, 'Elemental Forces Of Nature', 'G', 100, 'Animation', 'Peter Sohn', 'https://cdn.shopify.com/s/files/1/0037/8008/3782/products/IMG_0735_incinemas-219707.jpg?v=1674596999', 'https://www.youtube.com/embed/eoq-csWBPIg', 'Segera Tayang'),
    (6, 'The Flash', 'PG', 130, 'Adventure', 'Andy Muschietti', 'https://image.tmdb.org/t/p/original/rg8N7x27Ef6PvlIiioLStf9ZaIO.jpg', 'https://www.youtube.com/embed/jprhe-cWKGs', 'Segera Tayang'),
    (7, 'Angel: Kami Semua Punya Mimpi', 'PG-13', 105, 'Drama', 'Ivan Hamdani', 'https://m.media-amazon.com/images/M/MV5BMjY3NTg5NmItZTVhMy00NjEyLTgzZjEtYmU1M2Y1OWNkZTZjXkEyXkFqcGdeQXVyNzY4NDQzNTg@._V1_FMjpg_UX1000_.jpg', 'https://www.youtube.com/embed/eKTzrhtw0dA', 'Selesai Tayang'),
    (8, 'Sewu Dino', 'PG-13', 121, 'Horror', 'Kimo Stamboel', 'https://pbs.twimg.com/media/Fq27TL7aMAEeIhx.jpg:large', 'https://www.youtube.com/embed/12sXNFbQa6I', 'Selesai Tayang'),
    (9, 'Evil Dead Rise', 'R', 96, 'Horror', 'Lee Cronin', 'https://m.media-amazon.com/images/M/MV5BMmZiN2VmMjktZDE5OC00ZWRmLWFlMmEtYWViMTY4NjM3ZmNkXkEyXkFqcGdeQXVyMTI2MTc2ODM3._V1_FMjpg_UX1000_.jpg', 'https://www.youtube.com/embed/smTK_AeAPHs', 'Selesai Tayang'),
    (10, 'Ride On', 'PG', 126, 'Action', 'Larry Yang', 'https://m.media-amazon.com/images/M/MV5BMzVhZDU0MTQtNzkzOS00NjRlLWE5NGEtYWQ2YWJjZWZlYTkzXkEyXkFqcGdeQXVyMTUzMDA3Mjc2._V1_FMjpg_UX1000_.jpg', 'https://www.youtube.com/embed/mPxHMZsZs-8', 'Selesai Tayang');

INSERT INTO jadwal (j_id_jadwal, j_waktu, j_harga)
VALUES
    (1, '2023-04-18 12:30:00', 25000),
    (2, '2023-05-18 15:15:00', 25000),
    (3, '2023-05-18 18:00:00', 25000),
    (4, '2023-05-18 20:45:00', 25000),
	(5, '2023-05-19 12:30:00', 35000),
    (6, '2023-05-19 15:15:00', 35000),
    (7, '2023-05-19 18:00:00', 35000),
    (8, '2023-05-19 20:45:00', 35000),
	(9, '2023-05-20 12:30:00', 40000),
    (10, '2023-05-20 15:15:00', 40000),
    (11, '2023-05-20 18:00:00', 40000),
    (12, '2023-05-20 20:45:00', 40000),
	(13, '2023-06-08 12:30:00', 25000),
    (14, '2023-06-08 15:15:00', 25000),
    (15, '2023-06-08 18:00:00', 25000),
    (16, '2023-06-08 20:45:00', 25000),
	(17, '2023-06-09 12:30:00', 35000),
    (18, '2023-06-09 15:15:00', 35000),
    (19, '2023-06-09 18:00:00', 35000),
    (20, '2023-06-09 20:45:00', 35000),
	(21, '2023-06-10 12:30:00', 40000),
    (22, '2023-06-10 15:15:00', 40000),
    (23, '2023-06-10 18:00:00', 40000),
    (24, '2023-06-10 20:45:00', 40000),
	(25, '2023-06-22 12:30:00', 25000),
    (26, '2023-06-22 15:15:00', 25000),
    (27, '2023-06-22 18:00:00', 25000),
    (28, '2023-06-22 20:45:00', 25000),
	(29, '2023-06-23 12:30:00', 35000),
    (30, '2023-06-23 15:15:00', 35000),
    (31, '2023-06-23 18:00:00', 35000),
    (32, '2023-06-23 20:45:00', 35000),
	(33, '2023-06-24 12:30:00', 40000),
    (34, '2023-06-24 15:15:00', 40000),
    (35, '2023-06-24 18:00:00', 40000),
    (36, '2023-06-24 20:45:00', 40000);

INSERT INTO sesi_pemutaran (ss_id_sesi_pemutaran, ss_id_jadwal, ss_id_studio, ss_id_film)
VALUES
    (1, 1, 1, 1),
    (3, 3, 4, 2),
    (4, 4, 5, 2),
    (6, 6, 6, 4),
    (8, 8, 9, 6),
    (9, 9, 11, 8),
    (11, 11, 14, 1),
    (14, 14, 16, 2),
    (15, 15, 17, 6),
    (16, 16, 18, 7),
    (17, 17, 21, 2),
    (18, 18, 21, 4),
    (19, 19, 2, 7),
	(21, 21, 2, 6),
    (26, 26, 8, 1),
    (27, 27, 3, 4),
    (29, 29, 3, 9);

INSERT INTO transaksi (t_id_transaksi, t_waktu, t_total_harga, t_status, t_metode_pembayaran, t_id_customer, t_id_sesi_pemutaran)
VALUES
    (1, '2023-05-18 11:00:00', 75000, 'Berhasil', 'Transfer Bank', 1, 1),
    (2, '2023-05-18 14:30:00', 25000, 'Berhasil', 'Ovo', 5, 1),
    (3, '2023-05-18 16:45:00', 25000, 'Berhasil', 'Transfer Bank', 1, 1),
    (4, '2023-05-19 11:30:00', 35000, 'Berhasil', 'Dana', 1, 1),
	(5, '2023-05-19 11:33:00', 210000, 'Berhasil', 'Transfer Bank', 4, 1);
	
INSERT INTO kursi (k_id_kursi, k_nama, k_status, k_id_sesi_pemutaran, k_id_transaksi) 
VALUES 
	(1, 'A1', 'Kosong', 1, null),
	(2, 'A2', 'Kosong', 1, null),
	(3, 'A3', 'Kosong', 1, null),
	(5, 'D1', 'Kosong', 3, null),
	(6, 'A1', 'Kosong', 4, null),
	(7, 'A1', 'Kosong', 6, null),
	(8, 'A2', 'Kosong', 6, null),
	(9, 'A3', 'Kosong', 6, null),
	(10, 'A4', 'Kosong', 6, null),
	(11, 'A5', 'Kosong', 6, null),
	(12, 'A6', 'Kosong', 6, null),
	(13, 'B1', 'Kosong', 6, null),
	(14, 'B2', 'Kosong', 6, null),
	(15, 'A1', 'Kosong', 8, null),
	(16, 'A2', 'Kosong', 8, null),
	(17, 'A3', 'Kosong', 8, null),
	(18, 'A4', 'Kosong', 8, null),
	(19, 'D1', 'Kosong', 8, null),
	(20, 'D2', 'Kosong', 8, null),
	(21, 'B1', 'Kosong', 9, null),
	(22, 'B2', 'Kosong', 9, null),
	(23, 'B3', 'Kosong', 9, null),
	(24, 'B4', 'Kosong', 9, null),
	(25, 'A1', 'Kosong', 11, null),
	(26, 'A1', 'Kosong', 11, null),
	(27, 'A2', 'Kosong', 11, null),
	(28, 'A3', 'Terisi', 11, null),
	(29, 'A4', 'Terisi', 11, null),
	(30, 'A5', 'Terisi', 11, null),
	(31, 'A1', 'Terisi', 11, null),
	(32, 'A2', 'Terisi', 11, null),
	(33, 'B1', 'Kosong', 11, null),
	(34, 'B2', 'Kosong', 11, null),
	(35, 'A1', 'Kosong', 14, null),
	(36, 'A1', 'Terisi', 15, null),
	(37, 'C1', 'Terisi', 16, null),
	(38, 'C2', 'Terisi', 16, null),
	(39, 'C3', 'Terisi', 16, null),
	(40, 'C4', 'Terisi', 16, null),
	(41, 'C5', 'Terisi', 16, null),
	(42, 'C6', 'Terisi', 16, null),
	(43, 'C7', 'Terisi', 16, null),
	(44, 'A1', 'Kosong', 17, null),
	(45, 'A2', 'Kosong', 17, null),
	(46, 'A3', 'Kosong', 17, null),
	(47, 'A4', 'Kosong', 17, null),
	(48, 'A5', 'Kosong', 17, null),
	(49, 'C1', 'Terisi', 18, null),
	(50, 'A1', 'Terisi', 19, null),
	(51, 'A2', 'Terisi', 19, null),
	(52, 'B1', 'Kosong', 19, null),
	(53, 'D1', 'Terisi', 21, null),
	(54, 'D2', 'Terisi', 21, null),
	(55, 'D3', 'Kosong', 21, null),
	(56, 'D4', 'Kosong', 21, null),
	(57, 'D5', 'Kosong', 21, null),
	(58, 'C1', 'Kosong', 21, null),
	(59, 'C2', 'Kosong', 21, null),
	(60, 'C3', 'Kosong', 21, null),
	(61, 'C4', 'Kosong', 21, null),
	(62, 'C5', 'Kosong', 21, null),
	(63, 'C6', 'Kosong', 26, null),
	(64, 'A1', 'Kosong', 26, null),
	(65, 'A1', 'Kosong', 26, null),
	(66, 'A2', 'Kosong', 26, null),
	(67, 'A3', 'Kosong', 26, null),
	(68, 'A4', 'Kosong', 26, null),
	(69, 'A5', 'Kosong', 26, null),
	(70, 'A6', 'Kosong', 26, null),
	(71, 'A1', 'Kosong', 26, null),
	(72, 'B1', 'Kosong', 26, null),
	(73, 'B2', 'Kosong', 26, null),
	(74, 'B3', 'Kosong', 26, null),
	(75, 'B4', 'Kosong', 26, null),
	(76, 'A1', 'Terisi', 26, null),
	(77, 'A2', 'Terisi', 26, null),
	(78, 'A3', 'Terisi', 26, null),
	(79, 'A4', 'Kosong', 26, null),
	(80, 'A5', 'Kosong', 26, null),
	(81, 'A6', 'Kosong', 26, null),
	(82, 'A7', 'Kosong', 26, null),
	(83, 'A8', 'Kosong', 26, null),
	(84, 'A9', 'Kosong', 26, null),
	(85, 'A10', 'Kosong', 27, null),
	(86, 'A11', 'Kosong', 27, null),
	(87, 'A12', 'Kosong', 27, null),
	(88, 'A13', 'Kosong', 27, null),
	(89, 'A14', 'Kosong', 27, null),
	(90, 'A15', 'Kosong', 27, null),
	(91, 'A16', 'Kosong', 27, null),
	(92, 'A17', 'Kosong', 27, null),
	(93, 'A18', 'Kosong', 27, null),
	(94, 'B1', 'Kosong', 29, null),
	(95, 'B2', 'Kosong', 29, null),
	(96, 'B3', 'Kosong', 29, null),
	(97, 'B4', 'Kosong', 29, null),
	(98, 'B5', 'Kosong', 29, null),
	(99, 'B6', 'Kosong', 29, null),
	(100, 'B7', 'Kosong', 29, null),
	(101, 'B8', 'Kosong', 29, null),
	(102, 'A1', 'Kosong', 29, null),
	(103, 'A2', 'Kosong', 29, null),
	(104, 'A3', 'Kosong', 29, null),
	(105, 'C1', 'Kosong', 29, null),
	(106, 'C2', 'Terisi', 29, 1),
	(107, 'C3', 'Terisi', 29, 1),
	(108, 'C4', 'Terisi', 29, 1);

-- configure trigger
-- Membuat index judul film
CREATE INDEX idx_film_judul ON film (f_judul);

-- Membuat trigger di tabel transaksi
CREATE OR REPLACE FUNCTION set_transaksi_waktu()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.t_waktu := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Menambahkan trigger ke tabel transaksi
CREATE TRIGGER set_transaksi_waktu_trigger
BEFORE INSERT ON transaksi
FOR EACH ROW
EXECUTE FUNCTION set_transaksi_waktu();
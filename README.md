Flutter List Product

Aplikasi Flutter untuk menampilkan daftar produk menggunakan API dari "DummyJSON Products" (https://dummyjson.com/docs/products).

Fitur

- Menampilkan daftar produk.
- Mencari produk melalui fitur search.
- Melihat detail produk dengan memilih produk dari halaman utama.
- Tampilan menggunakan skema warna pastel.

Teknologi

- Flutter
- Dart
- DummyJSON Products API

Demo Aplikasi

Video demo: [https://youtu.be/eeaX4QPQOKw?si=jJwMAjngNhkA3HDt]
## Backend PHP/MySQL (CRUD)

> **Catatan lingkungan:** backend dijalankan dengan **XAMPP** (Apache/PHP + MariaDB), bukan Docker, karena keterbatasan perangkat (laptop RAM 4 GB) dan pengujian dilakukan di HP fisik lewat Wi-Fi/hotspot yang sama.

- Folder `backend/`: `api`, `config`, `seed`, `sql`. Database: `app`, user `app`.
- Setup: impor `backend/sql/schema.sql`, lalu (opsional) data awal lewat `backend/seed/import_products.php`.
- Password DB: buat `backend/config/credentials.local.php` (tidak ikut git):
  `<?php return ['password' => 'PASSWORD_DB_KAMU'];`
- Jalankan server dev (MySQL XAMPP harus hidup): `E:\xampp\php\php.exe -S 0.0.0.0:8000 -t backend`
- Endpoint `/api/products.php`: `GET` (list), `GET ?id=`, `POST`, `PUT ?id=`, `DELETE ?id=`. Respons `{success, data | message}`.
- Flutter: ubah `kBaseUrl` di `lib/services/api_services_products.dart` ke IP laptop (satu jaringan dengan HP). Izinkan port 8000 di firewall Windows.
- UI: tombol **+** untuk tambah; tekan lama kartu produk untuk edit atau hapus.
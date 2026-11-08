# Dokumentasi PBB Produk Bawaan
### Flutter + PHP + MySQL

**Terakhir diperbarui:** 8 November 2026

## 1. Ringkasan Proyek

PBB Produk Bawaan merupakan aplikasi berbasis Flutter untuk menampilkan dan mengelola data produk.

Pada versi awal, aplikasi menggunakan API publik DummyJSON sebagai sumber data. Pengguna hanya dapat melihat daftar produk.

Pada pengembangan selanjutnya, aplikasi dihubungkan dengan backend PHP dan database MySQL (MariaDB) yang dijalankan secara lokal menggunakan XAMPP.

Dengan perubahan tersebut, aplikasi mendukung operasi CRUD (Create, Read, Update, Delete).

Fitur utama aplikasi:
- Menampilkan daftar produk.
- Melihat informasi produk.
- Mencari produk.
- Menambahkan produk.
- Mengedit informasi produk.
- Mengubah URL gambar produk.
- Menghapus produk.

## 2. Asal dan Referensi Proyek

Proyek ini dikembangkan berdasarkan dua repository:

| Bagian | Repository |
|---|---|
| Aplikasi Flutter awal | [flutter-list-product](https://github.com/dulcodingz/flutter-list-product) |
| Referensi backend PHP/MySQL | [pcc_sample_php_mysql_services](https://github.com/vpratama/pcc_sample_php_mysql_services) |

Pengembangan dilakukan dengan mempertahankan aplikasi Flutter yang sudah ada, kemudian mengganti sumber data dari API publik menjadi backend dan database sendiri.

## 3. Perubahan yang Dilakukan

| File | Perubahan |
|---|---|
| `backend/api/products.php` | Mengembangkan endpoint dari GET saja menjadi CRUD lengkap. |
| `backend/config/database.php` | Mengatur koneksi database menggunakan PDO dan membaca password dari konfigurasi lokal. |
| `backend/config/credentials.local.php` | Menyimpan password database secara lokal. |
| `backend/seed/import_products.php` | Menambahkan proses impor data awal dari DummyJSON. |
| `lib/services/api_services_products.dart` | Mengubah alamat API ke backend sendiri, menyesuaikan format respons, serta menambahkan fungsi tambah, edit, dan hapus produk. |
| `lib/providers/product_provider.dart` | Menambahkan pengelolaan data produk dan penanganan error. |
| `lib/screens/product_form_screen.dart` | Membuat halaman form untuk menambahkan dan mengedit produk. |
| `lib/main.dart` | Menambahkan tombol tambah, menu Edit/Hapus melalui tekan lama kartu produk, konfirmasi penghapusan, dan penanganan error. |
| `android/.../AndroidManifest.xml` | Menambahkan izin INTERNET dan `usesCleartextTraffic` karena API menggunakan HTTP. |

Form tambah dan edit produk mencakup:
- Judul produk.
- Kategori.
- Brand.
- Harga.
- Stok.
- URL thumbnail.
- Deskripsi.

## 4. Lingkungan Pengembangan

### 4.1. Teknologi yang Digunakan

| Komponen | Teknologi |
|---|---|
| Framework aplikasi | Flutter |
| Bahasa aplikasi | Dart |
| Backend | PHP |
| Database | MySQL/MariaDB |
| Database management | phpMyAdmin |
| Web server | PHP Development Server |
| Lingkungan database | XAMPP |
| API awal | DummyJSON |
| Terminal | Windows PowerShell |
| Bantuan pengembangan | Claude AI |
| Version control | Git dan GitHub |

### 4.2. Alasan Menggunakan XAMPP

Pada repository referensi, backend menggunakan Docker dan beberapa service pendukung.

Namun, pengembangan proyek ini menggunakan XAMPP sebagai alternatif karena keterbatasan spesifikasi laptop, yaitu RAM 4 GB.

Docker Desktop membutuhkan penggunaan RAM yang cukup besar sehingga kurang sesuai dengan kondisi perangkat.

Dengan XAMPP, kebutuhan pengembangan backend dapat dijalankan lebih ringan menggunakan PHP dan MySQL.

### 4.3. Workflow Pengembangan

Pengembangan kode dilakukan melalui PowerShell dengan bantuan Claude AI.

PowerShell digunakan untuk:
- Berpindah direktori proyek.
- Membuat dan mengubah file.
- Menjalankan perintah PHP.
- Menjalankan perintah Flutter.
- Menguji endpoint API.
- Mengelola repository Git.

Claude AI digunakan sebagai asisten untuk membantu penulisan, pemeriksaan, dan perbaikan kode.

Karena laptop memiliki RAM 4 GB, workflow dibuat sesederhana mungkin tanpa harus menjalankan Visual Studio Code bersamaan dengan aplikasi lain yang membutuhkan banyak sumber daya.

## 5. Arsitektur Sistem

Sistem menggunakan laptop sebagai server backend dan HP sebagai perangkat pengguna aplikasi.

### 5.1. Alur Koneksi

Pengujian menggunakan jaringan hotspot HP.

```text
              HP Hotspot
                  |
                Wi-Fi
                  |
          +-------+-------+
          |               |
        Laptop          HP Penguji
          |               |
    +-----+------+        |
    |            |        |
  MySQL       PHP Server  |
  XAMPP       Port 8000   |
    |            |        |
    +------ Backend API -+
                   |
              Flutter APK
```

Keterangan:
- Laptop menjalankan database MySQL melalui XAMPP.
- Laptop menjalankan backend PHP melalui PHP Development Server.
- HP menjalankan aplikasi Flutter yang sudah diinstal dalam bentuk APK.
- Komunikasi antara HP dan laptop menggunakan jaringan Wi-Fi yang sama.

### 5.2. Alamat Backend

Backend dapat diakses melalui:

```text
http://IP_LAPTOP:8000
```

Contoh:

```text
http://10.65.244.151:8000
```

Alamat tersebut merupakan contoh IP lokal, bukan alamat permanen.

IP laptop dapat berubah ketika tersambung kembali ke hotspot atau jaringan Wi-Fi yang berbeda.

Jika IP berubah, alamat API di aplikasi Flutter harus disesuaikan.

## 6. Struktur Backend

```text
backend/
├── api/
│   └── products.php
├── config/
│   ├── database.php
│   └── credentials.local.php
├── seed/
│   └── import_products.php
└── sql/
    └── schema.sql
```

Keterangan:

| File | Fungsi |
|---|---|
| `api/products.php` | Menangani permintaan CRUD produk. |
| `config/database.php` | Mengatur koneksi database menggunakan PDO. |
| `config/credentials.local.php` | Menyimpan password database secara lokal. |
| `seed/import_products.php` | Mengimpor data produk awal dari DummyJSON. |
| `sql/schema.sql` | Menyediakan struktur database dan tabel produk. |

## 7. Dokumentasi REST API

Endpoint utama:

```text
/api/products.php
```

### 7.1. Daftar Endpoint

| Method | URL | Fungsi |
|---|---|---|
| GET | `/api/products.php` | Mengambil seluruh daftar produk. |
| GET | `/api/products.php?id=1` | Mengambil detail produk berdasarkan ID. |
| POST | `/api/products.php` | Menambahkan produk baru. |
| PUT | `/api/products.php?id=1` | Memperbarui produk berdasarkan ID. |
| DELETE | `/api/products.php?id=1` | Menghapus produk berdasarkan ID. |

### 7.2. Format Respons

Contoh respons GET daftar produk:

```json
{
  "success": true,
  "data": []
}
```

GET detail produk mengembalikan data produk jika ditemukan atau HTTP 404 jika tidak ditemukan.

POST dan PUT mengembalikan data produk setelah berhasil disimpan.

DELETE mengembalikan status keberhasilan dan pesan penghapusan.

### 7.3. Penanganan Data

Backend mengambil daftar kolom yang tersedia secara otomatis dari tabel `products`.

Field yang tidak dikenal akan diabaikan.

Nilai berbentuk array atau objek, seperti:
- `tags`
- `images`
- `reviews`
- `dimensions`
- `meta`

disimpan dalam database sebagai JSON string.

## 8. Konfigurasi Database dan Backend

### 8.1. Konfigurasi Database

Database menggunakan MySQL/MariaDB yang disediakan oleh XAMPP.

Database yang digunakan bernama:

```text
app
```

Koneksi database dikelola melalui:

```text
backend/config/database.php
```

Password database disimpan secara terpisah dalam:

```text
backend/config/credentials.local.php
```

Contoh isi file:

```php
<?php

return [
    'password' => 'PASSWORD_DB_KAMU'
];
```

Sesuaikan password dengan konfigurasi user database yang digunakan.

File kredensial ini bersifat lokal dan tidak boleh diunggah ke repository GitHub.

### 8.2. Mengimpor Data Awal

Data awal produk dapat diambil dari DummyJSON melalui script:

```text
backend/seed/import_products.php
```

Jalankan melalui PowerShell:

```powershell
E:\xampp\php\php.exe backend\seed\import_products.php
```

Setelah proses berhasil, data produk akan tersimpan di database sendiri dan dapat diakses melalui backend.

## 9. Cara Menjalankan Proyek dari Awal

Bagian ini digunakan ketika ingin menjalankan kembali proyek dari awal atau setelah laptop dimatikan.

### 9.1. Menyalakan XAMPP

1. Buka XAMPP Control Panel.
2. Klik Start pada MySQL.
3. Pastikan MySQL berstatus Running.

Apache tidak wajib dinyalakan untuk menjalankan API karena backend menggunakan PHP Development Server.

Apache dapat dinyalakan jika membutuhkan phpMyAdmin melalui browser:

```text
http://localhost/phpmyadmin
```

### 9.2. Menjalankan PHP Development Server

Buka PowerShell dan masuk ke direktori proyek:

```powershell
cd F:\Flutta\pbb_produk_bawaan
```

Kemudian jalankan:

```powershell
E:\xampp\php\php.exe -S 0.0.0.0:8000 -t backend
```

Jika berhasil, server akan berjalan pada port 8000.

Biarkan terminal tetap terbuka selama backend digunakan.

### 9.3. Mengatur Windows Firewall

Jika koneksi dari HP tidak dapat masuk ke laptop, pastikan port 8000 diizinkan oleh Windows Firewall.

Jalankan PowerShell sebagai Administrator:

```powershell
New-NetFirewallRule `
  -DisplayName "PHP 8000" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 8000 `
  -Action Allow `
  -Profile Any
```

Aturan ini cukup dibuat satu kali selama masih tersedia dan tidak dihapus.

### 9.4. Memeriksa IP Laptop

Jalankan:

```powershell
ipconfig
```

Cari bagian adapter Wi-Fi yang sedang terhubung ke hotspot.

Contoh:

```text
IPv4 Address: 10.65.244.151
```

### 9.5. Mengatur Base URL Flutter

Buka file:

```text
lib/services/api_services_products.dart
```

Sesuaikan nilai `kBaseUrl` dengan IP laptop:

```dart
const String kBaseUrl = 'http://10.65.244.151:8000';
```

Gunakan IP aktual laptop.

### 9.6. Menjalankan Flutter

Pastikan HP terhubung melalui USB dan USB Debugging sudah aktif.

Jalankan:

```powershell
flutter pub get
flutter devices
flutter run -d ID_HP
```

Aplikasi akan dijalankan langsung pada HP untuk keperluan pengembangan dan pengujian.

## 10. Cara Menjalankan APK yang Sudah Terinstal

**Penting: APK tetap membutuhkan backend yang berjalan di laptop.**

Walaupun aplikasi sudah terinstal di HP, database dan PHP server tidak otomatis berjalan bersama aplikasi.

Jika laptop mati, MySQL berhenti, atau PHP server tidak aktif, aplikasi tidak dapat mengambil maupun menyimpan data.

### 10.1. Langkah Menyalakan Server

Setiap kali ingin menggunakan APK, lakukan langkah berikut.

**Langkah 1 — Aktifkan hotspot**

- Nyalakan hotspot HP.
- Hubungkan laptop ke hotspot.
- Pastikan HP yang digunakan untuk membuka APK juga terhubung ke jaringan yang sama.

**Langkah 2 — Nyalakan MySQL**

1. Buka XAMPP Control Panel.
2. Klik Start pada MySQL.
3. Pastikan statusnya Running.

**Langkah 3 — Buka tab PowerShell baru**

Buka tab PowerShell baru agar terminal server terpisah dari terminal lainnya.

Masuk ke folder proyek:

```powershell
cd F:\Flutta\pbb_produk_bawaan
```

**Langkah 4 — Jalankan PHP server**

```powershell
E:\xampp\php\php.exe -S 0.0.0.0:8000 -t backend
```

Tunggu sampai muncul informasi bahwa server sudah berjalan.

**Jangan tutup tab PowerShell tersebut.**

PHP Development Server akan berhenti jika prosesnya dihentikan atau terminal ditutup.

**Langkah 5 — Buka APK**

Sekarang buka aplikasi PBB Produk Bawaan di HP.

Pastikan laptop tetap menyala, MySQL dan PHP server tetap berjalan, serta kedua perangkat masih berada pada jaringan yang sama.

### 10.2. Jika APK Menampilkan Gagal Memuat Data

Jika APK gagal memuat data, periksa hal berikut:

| Pemeriksaan | Tindakan |
|---|---|
| Laptop mati | Nyalakan laptop. |
| MySQL berhenti | Start MySQL melalui XAMPP. |
| PHP server mati | Jalankan kembali perintah PHP di PowerShell. |
| Tab PowerShell tertutup | Buka tab baru dan jalankan server kembali. |
| Jaringan berbeda | Hubungkan HP dan laptop ke jaringan yang sama. |
| IP berubah | Perbarui `kBaseUrl` dan sesuaikan APK. |

Jika hanya PHP server yang mati, cukup jalankan kembali perintah berikut:

```powershell
cd F:\Flutta\pbb_produk_bawaan

E:\xampp\php\php.exe -S 0.0.0.0:8000 -t backend
```

Tidak perlu menjalankan ulang Flutter atau melakukan build APK selama IP laptop masih sama.

### 10.3. Menghentikan Server

Untuk menghentikan PHP server:

1. Buka tab PowerShell tempat server berjalan.
2. Tekan `Ctrl + C`.

Untuk menghentikan database, klik Stop pada MySQL melalui XAMPP Control Panel.

## 11. Pengaturan IP Laptop

Alamat IP laptop merupakan alamat lokal yang diberikan oleh jaringan.

IP dapat berubah ketika:
- Laptop terhubung kembali ke hotspot.
- Laptop berpindah jaringan Wi-Fi.
- Jaringan memberikan alamat IP baru.

### 11.1. Jika IP Berubah

Misalnya sebelumnya:

```text
http://10.65.244.151:8000
```

Kemudian setelah tersambung kembali ke hotspot berubah menjadi:

```text
http://10.65.244.152:8000
```

Maka alamat pada `kBaseUrl` harus ikut diperbarui.

Langkahnya:

1. Jalankan `ipconfig`.
2. Cari IPv4 laptop yang sedang digunakan.
3. Ubah `kBaseUrl` di `api_services_products.dart`.
4. Terapkan perubahan sesuai cara menjalankan aplikasi.

### 11.2. Perbedaan Penggunaan

| Kondisi | Tindakan |
|---|---|
| IP tidak berubah, menggunakan APK | APK lama tetap bisa digunakan. |
| IP tidak berubah, development via USB | Hot restart jika diperlukan. |
| IP berubah, development via USB | Ubah `kBaseUrl`, kemudian hot restart. |
| IP berubah, menggunakan APK mandiri | Ubah `kBaseUrl`, build ulang APK, lalu instal versi terbaru. |

IP lokal pada konfigurasi aplikasi bukan alamat server publik. Pengguna lain yang menjalankan aplikasi pada jaringan berbeda harus menyesuaikan alamat backend mereka sendiri.

## 12. Pemetaan Data Flutter dan Backend

Backend menggunakan format kolom `snake_case`, sedangkan model Flutter menggunakan `camelCase`.

Contoh:

| Backend | Flutter |
|---|---|
| `discount_percentage` | `discountPercentage` |
| `thumbnail` | `thumbnail` |
| `stock` | `stock` |

Selain perbedaan penamaan, tipe data yang dikirim oleh backend juga perlu disesuaikan dengan kebutuhan model Flutter.

Fungsi `_fix` pada:

```text
lib/services/api_services_products.dart
```

bertugas menyesuaikan struktur dan tipe data respons API.

Dengan demikian, model pada `product_model.dart` tetap dapat digunakan tanpa harus mengubah keseluruhan struktur model hanya karena perbedaan format respons backend.

## 13. Hasil Pengujian

Pengujian dilakukan menggunakan aplikasi Flutter pada HP dan diverifikasi melalui phpMyAdmin.

| Fitur | Cara Pengujian | Hasil |
|---|---|---|
| Daftar produk | Membuka aplikasi di HP | Berhasil |
| Tambah produk | Menekan tombol `+` | Berhasil, data masuk database |
| Edit produk | Tekan lama kartu, pilih Edit | Berhasil, data berubah di database |
| Edit URL gambar | Mengubah URL thumbnail | Berhasil, gambar tampil dan tersimpan |
| Hapus produk | Tekan lama kartu, pilih Hapus | Berhasil, data terhapus |
| Verifikasi database | Memeriksa tabel `products` melalui phpMyAdmin | Sesuai dengan aksi aplikasi |

## 14. Masalah yang Pernah Terjadi

| Gejala | Penyebab | Solusi |
|---|---|---|
| Loading terus atau `Connection refused` | PHP server tidak berjalan atau IP salah | Jalankan PHP server dan periksa IP laptop. |
| `_Map<dynamic, dynamic> is not a subtype of Map<String, dynamic>` | Tipe Map hasil decoding JSON tidak sesuai | Seragamkan hasil melalui fungsi `_fix`. |
| Produk tidak tampil meskipun laptop menyala | PHP Development Server berhenti | Jalankan kembali PHP server melalui PowerShell. |
| APK gagal memuat data setelah laptop restart | PHP server belum dijalankan kembali | Nyalakan MySQL dan PHP server. |
| APK gagal setelah tersambung ke hotspot baru | IP laptop berubah | Perbarui `kBaseUrl` dan build ulang APK mandiri. |
| Jumlah produk lebih banyak dari data awal | Terdapat sisa data pengujian | Hapus data melalui fitur DELETE atau phpMyAdmin. |
| Gambar tidak tampil setelah perubahan URL | URL gambar tidak valid atau tidak dapat diakses | Periksa kembali URL thumbnail. |

## 15. Checklist Pengembangan Berikutnya

### Sebelum menjalankan aplikasi

- [ ] Laptop menyala.
- [ ] Hotspot atau Wi-Fi aktif.
- [ ] Laptop dan HP berada pada jaringan yang sama.
- [ ] MySQL XAMPP berstatus Running.
- [ ] PHP Development Server berjalan.
- [ ] Tab PowerShell server tidak ditutup.
- [ ] IP laptop sesuai dengan `kBaseUrl`.

### Sebelum mengubah kode

- [ ] Pastikan berada di direktori proyek yang benar.
- [ ] Periksa file yang akan diubah.
- [ ] Periksa dependensi yang digunakan.
- [ ] Uji perubahan melalui aplikasi atau endpoint API.

### Sebelum melakukan push ke GitHub

Periksa perubahan:

```powershell
git status
```

Pastikan file yang tidak seharusnya diunggah tidak ikut di-commit.

File kredensial lokal yang harus dijaga:

```text
backend/config/credentials.local.php
```

Periksa juga file backup seperti `.bak` dan file konfigurasi lokal lainnya.

Lakukan pemeriksaan:

```powershell
git diff --check
git diff --stat
```

Setelah memastikan perubahan benar, lakukan commit dan push.

## 16. Catatan Pengembangan

Proyek PBB Produk Bawaan merupakan pengembangan dari aplikasi Flutter yang sebelumnya menggunakan API publik DummyJSON menjadi aplikasi yang terhubung dengan backend PHP dan database MySQL sendiri.

Pengembangan dilakukan dengan mempertimbangkan keterbatasan perangkat sehingga penggunaan teknologi dibuat sesederhana dan seringan mungkin.

Penggunaan XAMPP menggantikan Docker, sedangkan PowerShell menjadi lingkungan utama untuk menjalankan perintah dan mengelola proyek dengan bantuan Claude AI.

Untuk pengembangan berikutnya, beberapa hal yang dapat ditingkatkan antara lain:

- Validasi input produk.
- Peningkatan penanganan error jaringan.
- Pengelolaan gambar produk.
- Pengamanan endpoint API.
- Penggunaan hosting agar backend dapat diakses tanpa bergantung pada laptop dan jaringan lokal.

Dokumentasi ini digunakan sebagai panduan menjalankan, menguji, dan melanjutkan pengembangan PBB Produk Bawaan.
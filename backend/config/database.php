<?php

$host = '127.0.0.1';
$dbname = 'app';
$username = 'app';
$password = 'GANTI_DI_credentials.local.php';
if (file_exists(__DIR__ . '/credentials.local.php')) {
    $c = require __DIR__ . '/credentials.local.php';
    $password = $c['password'] ?? $password;
}

try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    die("Koneksi database gagal: " . $e->getMessage());
}

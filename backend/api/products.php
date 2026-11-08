<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once __DIR__ . '/../config/database.php';

function out($code, $arr) {
    http_response_code($code);
    echo json_encode($arr);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'OPTIONS') out(204, []);

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$body = json_decode(file_get_contents('php://input'), true) ?: [];

try {
    $cols = [];
    foreach ($pdo->query("SHOW COLUMNS FROM products")->fetchAll(PDO::FETCH_ASSOC) as $c) {
        $def = strtolower((string)($c['Default'] ?? ''));
        if ($c['Field'] !== 'id' && stripos($c['Extra'], 'GENERATED') === false && strpos($def, 'current_timestamp') === false) {
            $cols[] = $c['Field'];
        }
    }
    
    $data = array_intersect_key($body, array_flip($cols));

    $find = function ($id) use ($pdo) {
        $s = $pdo->prepare("SELECT * FROM products WHERE id = ?");
        $s->execute([$id]);
        return $s->fetch(PDO::FETCH_ASSOC);
    };

    if ($method === 'GET') {
        if ($id) {
            $row = $find($id);
            if (!$row) out(404, ['success' => false, 'message' => 'Produk tidak ditemukan']);
            out(200, ['success' => true, 'data' => $row]);
        }
        $rows = $pdo->query("SELECT * FROM products ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC);
        out(200, ['success' => true, 'data' => $rows]);
    }

    if ($method === 'POST') {
        if (!$data) out(400, ['success' => false, 'message' => 'Data kosong']);
        
        // Handle incoming arrays/objects for JSON columns gracefully if passed as raw arrays from frontend
        foreach ($data as $key => $val) {
            if (is_array($val)) {
                $data[$key] = json_encode($val);
            }
        }

        $names = implode(',', array_map(fn($k) => "`$k`", array_keys($data)));
        $marks = implode(',', array_fill(0, count($data), '?'));
        
        $pdo->prepare("INSERT INTO products ($names) VALUES ($marks)")->execute(array_values($data));
        out(201, ['success' => true, 'data' => $find((int)$pdo->lastInsertId())]);
    }

    if ($method === 'PUT') {
        if (!$id || !$data) out(400, ['success' => false, 'message' => 'id/data wajib']);
        if (!$find($id)) out(404, ['success' => false, 'message' => 'Produk tidak ditemukan']);
        
        // Handle incoming arrays/objects for JSON columns gracefully
        foreach ($data as $key => $val) {
            if (is_array($val)) {
                $data[$key] = json_encode($val);
            }
        }

        $set = implode(',', array_map(fn($k) => "`$k` = ?", array_keys($data)));
        $pdo->prepare("UPDATE products SET $set WHERE id = ?")->execute([...array_values($data), $id]);
        out(200, ['success' => true, 'data' => $find($id)]);
    }

    if ($method === 'DELETE') {
        if (!$id) out(400, ['success' => false, 'message' => 'id wajib']);
        if (!$find($id)) out(404, ['success' => false, 'message' => 'Produk tidak ditemukan']);
        
        $pdo->prepare("DELETE FROM products WHERE id = ?")->execute([$id]);
        out(200, ['success' => true, 'message' => 'Produk dihapus']);
    }

    out(405, ['success' => false, 'message' => 'Method tidak didukung']);

} catch (PDOException $e) {
    out(500, ['success' => false, 'message' => 'Kesalahan database']);
}
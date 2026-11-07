<?php

require_once __DIR__ . '/../config/database.php';

$url = 'https://dummyjson.com/products?limit=0';

$ch = curl_init($url);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 60,
]);

$response = curl_exec($ch);
$error = curl_error($ch);
$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($response === false || $status !== 200) {
    die("Gagal mengambil data: $error (HTTP $status)\n");
}

$result = json_decode($response, true);

if (!isset($result['products']) || !is_array($result['products'])) {
    die("Format data dari DummyJSON tidak valid.\n");
}

$sql = "INSERT INTO products (
    id, title, description, category, price,
    discount_percentage, rating, stock, brand, sku,
    weight, warranty_information, shipping_information,
    availability_status, return_policy, minimum_order_quantity,
    thumbnail, tags, images, reviews, dimensions, meta
) VALUES (
    :id, :title, :description, :category, :price,
    :discount_percentage, :rating, :stock, :brand, :sku,
    :weight, :warranty_information, :shipping_information,
    :availability_status, :return_policy, :minimum_order_quantity,
    :thumbnail, :tags, :images, :reviews, :dimensions, :meta
)
ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    description = VALUES(description),
    category = VALUES(category),
    price = VALUES(price),
    discount_percentage = VALUES(discount_percentage),
    rating = VALUES(rating),
    stock = VALUES(stock),
    brand = VALUES(brand),
    sku = VALUES(sku),
    weight = VALUES(weight),
    warranty_information = VALUES(warranty_information),
    shipping_information = VALUES(shipping_information),
    availability_status = VALUES(availability_status),
    return_policy = VALUES(return_policy),
    minimum_order_quantity = VALUES(minimum_order_quantity),
    thumbnail = VALUES(thumbnail),
    tags = VALUES(tags),
    images = VALUES(images),
    reviews = VALUES(reviews),
    dimensions = VALUES(dimensions),
    meta = VALUES(meta)";

$stmt = $pdo->prepare($sql);

$pdo->beginTransaction();

try {
    $count = 0;

    foreach ($result['products'] as $p) {
        $stmt->execute([
            ':id' => $p['id'],
            ':title' => $p['title'],
            ':description' => $p['description'],
            ':category' => $p['category'],
            ':price' => $p['price'],
            ':discount_percentage' => $p['discountPercentage'] ?? 0,
            ':rating' => $p['rating'] ?? 0,
            ':stock' => $p['stock'] ?? 0,
            ':brand' => $p['brand'] ?? '',
            ':sku' => $p['sku'] ?? '',
            ':weight' => $p['weight'] ?? 0,
            ':warranty_information' => $p['warrantyInformation'] ?? '',
            ':shipping_information' => $p['shippingInformation'] ?? '',
            ':availability_status' => $p['availabilityStatus'] ?? '',
            ':return_policy' => $p['returnPolicy'] ?? '',
            ':minimum_order_quantity' => $p['minimumOrderQuantity'] ?? 1,
            ':thumbnail' => $p['thumbnail'] ?? '',
            ':tags' => json_encode($p['tags'] ?? []),
            ':images' => json_encode($p['images'] ?? []),
            ':reviews' => json_encode($p['reviews'] ?? []),
            ':dimensions' => json_encode($p['dimensions'] ?? new stdClass()),
            ':meta' => json_encode($p['meta'] ?? new stdClass()),
        ]);

        $count++;
    }

    $pdo->commit();

    echo "Import berhasil!\n";
    echo "Total produk diproses: $count\n";

} catch (Throwable $e) {
    $pdo->rollBack();
    die("Import gagal: " . $e->getMessage() . "\n");
}

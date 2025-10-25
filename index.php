<?php
// -----------------------------
// Conexión a PostgreSQL con PDO
// -----------------------------
$host = getenv('DB_HOST') ?: 'localhost';
$db   = getenv('DB_NAME') ?: 'miapp_db';
$user = getenv('DB_USER') ?: 'miapp_user';
$pass = getenv('DB_PASS') ?: 'password';
$port = getenv('DB_PORT') ?: 5432;

try {
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("❌ Error de conexión: " . $e->getMessage());
}

// -----------------------------
// Crear tabla si no existe
// -----------------------------
$conn->exec("
    CREATE TABLE IF NOT EXISTS alumnos (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL UNIQUE
    );
");

// -----------------------------
// Insertar registros de prueba sin duplicados
// -----------------------------
$insertSQL = "
    INSERT INTO alumnos (nombre, email) VALUES
    ('Ana López', 'ana@example.com'),
    ('Luis García', 'luis@example.com'),
    ('Marta Ruiz', 'marta@example.com')
    ON CONFLICT (email) DO NOTHING;
";

$conn->exec($insertSQL);

// -----------------------------
// Mostrar registros
// -----------------------------
echo "<h1>Lista de Alumnos</h1>";
echo "<table border='1' cellpadding='5'>";
echo "<tr><th>ID</th><th>Nombre</th><th>Email</th></tr>";

$stmt = $conn->query("SELECT * FROM alumnos ORDER BY id ASC");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "<tr>";
    echo "<td>" . htmlspecialchars($row['id']) . "</td>";
    echo "<td>" . htmlspecialchars($row['nombre']) . "</td>";
    echo "<td>" . htmlspecialchars($row['email']) . "</td>";
    echo "</tr>";
}

echo "</table>";

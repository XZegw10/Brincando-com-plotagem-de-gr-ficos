<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- A variável $pageTitle é definida no Controller que chama este layout -->
    <title><?= isset($pageTitle) ? htmlspecialchars($pageTitle) : 'Analisador de Primos' ?></title>

    <!-- Estilos e Fontes -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">

    <!-- Bibliotecas JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <?php
        // O conteúdo específico da página, definido pelo controller, será carregado aqui.
        // No nosso caso, o ChartController vai mandar carregar a view 'chart.php'.
        require_once __DIR__ . '/../pages/chart.php';
    ?>

    <!-- Carrega o nosso arquivo JavaScript principal no final do body para melhor performance -->
    <script src="js/app.js"></script>
</body>
</html>

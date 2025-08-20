<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- A variável $pageTitle é definida no Controller que chama este layout -->
    <title><?= isset($pageTitle) ? htmlspecialchars($pageTitle) : 'Analisador de Primos' ?></title>

    <!-- CDNs e Estilos -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        .loader { border-top-color: #3498db; animation: spin 1s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
        /* Estilização para o seletor de cor */
        input[type="color"] {
            -webkit-appearance: none;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            padding: 0;
        }
        input[type="color"]::-webkit-color-swatch-wrapper {
            padding: 0;
        }
        input[type="color"]::-webkit-color-swatch {
            border: 2px solid #4a5568;
            border-radius: 50%;
        }
    </style>
</head>
<body class="bg-gray-900 text-gray-200 flex flex-col items-center justify-center min-h-screen p-4">

    <?php
        // O conteúdo específico da página, definido pelo controller, será carregado aqui.
        // No nosso caso, o ChartController vai mandar carregar a view 'chart.php'.
        require_once __DIR__ . '/../pages/chart.php';
    ?>

    <!-- Carrega o nosso arquivo JavaScript principal no final do body para melhor performance -->
    <script src="js/app.js"></script>
</body>
</html>

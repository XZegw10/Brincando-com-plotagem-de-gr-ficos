<?php
// Define o caminho para o diretório de módulos.
$modules_path = 'modules';
$modules = [];

// Verifica se o diretório de módulos existe.
if (is_dir($modules_path)) {
    // Escaneia o diretório e filtra para pegar apenas as pastas.
    $items = scandir($modules_path);
    foreach ($items as $item) {
        // Ignora os diretórios '.' e '..' e verifica se é uma pasta.
        if ($item[0] !== '.' && is_dir($modules_path . '/' . $item)) {
            $modules[] = $item;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Galeria de Módulos</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-900 text-gray-200 flex flex-col items-center justify-center min-h-screen p-4">

    <div class="w-full max-w-4xl mx-auto text-center">
        <h1 class="text-4xl font-bold text-white mb-4">Galeria de Módulos</h1>
        <p class="text-lg text-gray-400 mb-12">Selecione um projeto abaixo para visualizar.</p>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <?php if (empty($modules)): ?>
                <div class="col-span-full text-center bg-gray-800 p-8 rounded-xl">
                    <p class="text-gray-400">Nenhum módulo encontrado no diretório <code><?= htmlspecialchars($modules_path) ?></code>.</p>
                </div>
            <?php else: ?>
                <?php foreach ($modules as $module): ?>
                    <?php
                        // Formata o nome do módulo para exibição (ex: 'prototipo_grafico' -> 'Prototipo Grafico')
                        $display_name = ucwords(str_replace('_', ' ', $module));
                        // Cria o link para a pasta public do módulo
                        $link = $modules_path . '/' . htmlspecialchars($module) . '/public/';
                    ?>
                    <a href="<?= $link ?>" class="block bg-gray-800 rounded-xl shadow-lg hover:bg-gray-700 hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 ease-in-out p-8">
                        <h2 class="text-2xl font-bold text-white"><?= htmlspecialchars($display_name) ?></h2>
                        <p class="text-gray-400 mt-2">Clique para iniciar</p>
                    </a>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>

</body>
</html>

<?php

/**
 * Autoloader PSR-4 Simples
 * Carrega as classes dos diretórios 'app/Models' e 'app/Controllers'
 * com base em seus namespaces.
 */
spl_autoload_register(function ($class) {
    // Define o prefixo do namespace do projeto.
    $prefix = 'App\\';
    // Define o diretório base para os arquivos do namespace.
    $base_dir = __DIR__ . '/../app/';

    // A classe usa o prefixo do namespace?
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        // Não, então passa para o próximo autoloader registrado.
        return;
    }

    // Pega o nome relativo da classe (ex: Controllers\ChartController)
    $relative_class = substr($class, $len);

    // Substitui o separador de namespace (\) pelo separador de diretório (/)
    // e adiciona .php no final.
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';

    // Se o arquivo existir, carrega-o.
    if (file_exists($file)) {
        require $file;
    }
});

// Usando o namespace do nosso controller para facilitar a instanciação.
use App\Controllers\ChartController;

/**
 * Roteador Simples
 * Analisa a URL para determinar qual ação do controller deve ser executada.
 */

// Pega o parâmetro 'action' da URL. Se não existir, o padrão é 'show'.
$action = $_GET['action'] ?? 'show';

// Instancia o nosso único controller.
$controller = new ChartController();

// Executa a ação apropriada com base no parâmetro 'action'.
switch ($action) {
    case 'getPrimeData':
        // Se a ação for 'getPrimeData', chama o método da API.
        $controller->getPrimeData();
        break;

    case 'show':
    default:
        // Para qualquer outra ação ou o padrão, mostra a página principal.
        $controller->show();
        break;
}

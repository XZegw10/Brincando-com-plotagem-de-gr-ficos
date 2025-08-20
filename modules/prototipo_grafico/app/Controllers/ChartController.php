<?php

namespace App\Controllers;

use App\Models\PrimeCalculator;

class ChartController
{
    /**
     * Exibe a página principal do gráfico.
     * Este método é responsável por carregar o layout e a view da página principal.
     */
    public function show()
    {
        // Define o título da página, que pode ser usado no layout.
        $pageTitle = 'Analisador Interativo da Razão entre Primos';

        // Inclui o layout principal que encapsula o conteúdo da página.
        // O layout cuidará do <head>, <body> e outras estruturas comuns.
        require_once __DIR__ . '/../Views/layouts/main.php';
    }

    /**
     * Endpoint da API para calcular e retornar dados de números primos.
     * Acessado via AJAX pelo frontend.
     */
    public function getPrimeData()
    {
        // Pega o parâmetro 'count' da URL, garantindo que seja um inteiro.
        $count = filter_input(INPUT_GET, 'count', FILTER_VALIDATE_INT, [
            'options' => ['default' => 5000, 'min_range' => 2, 'max_range' => 100000]
        ]);

        // Se a validação do filtro falhar, retorna um erro.
        if ($count === false) {
            http_response_code(400); // Bad Request
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Parâmetro "count" inválido. Deve ser um inteiro entre 2 e 100.000.']);
            return;
        }

        $calculator = new PrimeCalculator();
        $primes = $calculator->generatePrimes($count);

        // Envia a resposta como JSON.
        header('Content-Type: application/json');
        echo json_encode(['primes' => $primes]);
    }
}

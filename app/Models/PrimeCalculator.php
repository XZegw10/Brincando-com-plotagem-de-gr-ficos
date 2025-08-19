<?php

namespace App\Models;

class PrimeCalculator
{
    /**
     * Gera os primeiros n números primos.
     *
     * @param int $n O número de primos a gerar.
     * @return int[] Um array contendo os números primos.
     */
    public function generatePrimes(int $n): array
    {
        if ($n <= 0) {
            return [];
        }

        // Otimização: Define o limite de tempo de execução para evitar timeouts em cálculos longos.
        // 120 segundos deve ser suficiente para 100.000 primos.
        set_time_limit(120);

        $primes = [2];
        $num = 3;

        while (count($primes) < $n) {
            $isPrime = true;
            // Otimização: Usar a raiz quadrada do número atual como limite do loop
            $sqrtNum = sqrt($num);
            foreach ($primes as $p) {
                if ($p > $sqrtNum) {
                    break;
                }
                if ($num % $p === 0) {
                    $isPrime = false;
                    break;
                }
            }
            if ($isPrime) {
                $primes[] = $num;
            }
            // Otimização: Apenas números ímpares são candidatos a primos (exceto o 2)
            $num += 2;
        }

        return $primes;
    }
}

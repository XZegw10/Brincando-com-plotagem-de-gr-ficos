# Analisador Interativo da Razão entre Primos

Este é um projeto de aplicação web para visualização e análise interativa da razão entre números primos consecutivos, $\frac{p_n}{p_{n-1}}$. A aplicação permite aos usuários gerar um grande número de primos, visualizar a tendência dessa razão e compará-la com uma curva teórica e uma média móvel ajustável.

## 📜 Sumário

- [✨ Funcionalidades](#-funcionalidades)
- [⚙️ Como Funciona](#️-como-funciona)
- [🚀 Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [🔧 Como Executar o Projeto](#-como-executar-o-projeto)
- [📂 Estrutura do Projeto](#-estrutura-do-projeto)
- [💻 Análise do Código](#-análise-do-código)

## ✨ Funcionalidades

- **Geração de Primos no Lado do Servidor**: Calcula de forma eficiente até 100.000 números primos usando PHP.
- **Visualização de Dados Interativa**: Renderiza um gráfico usando Chart.js para exibir:
    - A razão bruta $\frac{p_n}{p_{n-1}}$ para cada primo.
    - Uma **média móvel** suavizada da razão, com janela ajustável.
    - Uma **curva teórica** de $1 + \frac{1}{\ln(p_n)}$, que se aproxima da razão para primos grandes.
- **Controles Intuitivos**:
    - Selecione o número de primos a serem analisados.
    - Ajuste o tamanho da janela da média móvel com um controle deslizante.
    - Botão para atualizar o gráfico com novos parâmetros.
- **Customização em Tempo Real**:
    - Altere as cores dos pontos de dados, da linha da média móvel e da curva teórica.
    - Ative ou desative a exibição dos pontos de dados brutos.
    - Ajuste o tamanho dos pontos de dados.
- **Interface Responsiva**: Layout construído com Tailwind CSS que se adapta a diferentes tamanhos de tela.
- **Feedback de Carregamento**: Exibe um indicador de carregamento enquanto os cálculos de primos são realizados no servidor, melhorando a experiência do usuário.

## ⚙️ Como Funciona

A aplicação segue uma arquitetura cliente-servidor simples:

1.  **Requisição do Cliente**: O usuário define o número de primos desejado na interface e clica em "Atualizar Gráfico".
2.  **Chamada de API**: O JavaScript do frontend faz uma chamada `fetch` para um endpoint da API em PHP (`index.php?action=getPrimeData`).
3.  **Processamento no Servidor**:
    - O `ChartController.php` recebe a requisição.
    - Ele invoca o `PrimeCalculator.php`, que gera a lista de números primos usando um algoritmo otimizado (crivo de Eratóstenes modificado).
    - O servidor retorna a lista de primos em formato JSON.
4.  **Renderização no Cliente**:
    - O JavaScript (`app.js`) recebe os dados.
    - Ele calcula a razão $\frac{p_n}{p_{n-1}}$, a média móvel e os valores da curva teórica.
    - Usando a biblioteca **Chart.js**, ele renderiza (ou atualiza) o gráfico com os três conjuntos de dados.
    - Todas as customizações (cores, tamanho dos pontos) são aplicadas em tempo real, sem a necessidade de buscar novos dados.

## 🚀 Tecnologias Utilizadas

- **Backend**:
    - **PHP**: Linguagem de script do lado do servidor para a lógica de negócio e geração de primos.
- **Frontend**:
    - **HTML5**: Estrutura da página.
    - **Tailwind CSS**: Framework CSS para estilização rápida e responsiva.
    - **JavaScript (ES6+)**: Manipulação do DOM, interatividade e lógica do cliente.
    - **Chart.js**: Biblioteca para a criação de gráficos interativos e visualmente atraentes.
- **Arquitetura**:
    - **MVC (Model-View-Controller)**: Padrão de arquitetura para organizar o código do lado do servidor.
    - **API RESTful Simples**: Para a comunicação entre o frontend e o backend.

## 🔧 Como Executar o Projeto

Para executar este projeto, você precisará de um ambiente de servidor local com suporte a PHP, como XAMPP, WAMP, MAMP ou o servidor embutido do PHP.

1.  **Clone o repositório**:
    ```bash
    git clone <URL_DO_REPOSITORIO>
    cd <NOME_DA_PASTA>
    ```

2.  **Inicie um servidor local**:
    - Navegue até a pasta `public` do projeto.
    - Use o servidor embutido do PHP para uma configuração rápida:
      ```bash
      cd public
      php -S localhost:8000
      ```

3.  **Acesse no navegador**:
    - Abra seu navegador e acesse `http://localhost:8000`.

A aplicação deve carregar, buscar os dados iniciais (5.000 primos por padrão) e exibir o gráfico.

## 📂 Estrutura do Projeto

O projeto está organizado usando uma estrutura baseada no padrão MVC:

```
.
├── app/
│   ├── Controllers/
│   │   └── ChartController.php   # Controla as requisições e a lógica da aplicação.
│   ├── Models/
│   │   └── PrimeCalculator.php   # Responsável pelo cálculo dos números primos.
│   └── Views/
│       ├── layouts/
│       │   └── main.php          # Layout principal da página (template).
│       └── pages/
│           └── chart.php         # View principal com os elementos da interface.
└── public/
    ├── js/
    │   └── app.js                # Lógica do frontend (Chart.js, eventos, API).
    └── index.php                 # Ponto de entrada (roteador principal).
```

## 💻 Análise do Código

### `public/index.php`

Este é o ponto de entrada da aplicação. Ele atua como um roteador simples, direcionando as requisições para o método apropriado no `ChartController`.

- Se a URL contém `action=getPrimeData`, ele chama `getPrimeData()` para retornar os dados dos primos.
- Caso contrário, ele chama `show()` para renderizar a página principal.

### `app/Controllers/ChartController.php`

- **`show()`**: Este método é responsável por carregar a página principal. Ele simplesmente inclui o arquivo de layout `main.php`, que por sua vez carrega a view `chart.php`.
- **`getPrimeData()`**: Este é o endpoint da API. Ele:
    - Valida o parâmetro `count` da requisição GET.
    - Instancia `PrimeCalculator` para gerar os números primos.
    - Retorna os dados como uma resposta JSON.

### `app/Models/PrimeCalculator.php`

- **`generatePrimes(int $n)`**: Contém a lógica principal para o cálculo de primos. As otimizações incluem:
    - Iniciar com 2 e testar apenas números ímpares.
    - Usar a raiz quadrada do número candidato como limite para a verificação de divisores.
    - `set_time_limit(120)` para evitar timeouts do PHP em cálculos longos.

### `app/Views/pages/chart.php`

Define a estrutura HTML da interface do usuário, incluindo:
- Inputs para o número de primos e controles deslizantes para a média móvel e tamanho dos pontos.
- Seletores de cor para customização.
- Um elemento `<canvas>` onde o Chart.js renderizará o gráfico.
- Um contêiner para o indicador de carregamento.

### `public/js/app.js`

Este é o coração do frontend. Ele é encapsulado em um objeto `PrimeAnalyzerApp` para organização.
- **`init()`**: Inicializa a aplicação, mapeia os elementos do DOM e define os ouvintes de eventos.
- **`cacheDom()`**: Armazena referências aos elementos do DOM para acesso rápido.
- **`bindEvents()`**: Adiciona `event listeners` para os botões e controles. Utiliza uma função `debounce` para otimizar eventos frequentes (como o controle deslizante), evitando atualizações excessivas.
- **`handleUpdate()`**: Função assíncrona que:
    - Mostra o loader.
    - Faz a chamada `fetch` para a API do backend.
    - Processa os dados recebidos (calcula razões).
    - Chama `createOrUpdateChart()` para renderizar o gráfico.
    - Esconde o loader.
- **`createOrUpdateChart()`**: Destrói o gráfico antigo (se existir) e cria um novo com os dados atualizados, configurando os três conjuntos de dados (razão, média móvel, curva teórica).
- **`updateChartAppearance()` e `updateMovingAverage()`**: Funções que atualizam o gráfico em tempo real em resposta às interações do usuário, sem a necessidade de buscar novos dados do servidor.
- **`calculateMovingAverage()`**: Uma função utilitária para calcular a média móvel simples sobre os dados da razão.

# Repositório de Módulos Centralizados

Este é um projeto de arquitetura modular, projetado para funcionar como uma central de projetos descentralizados, mas conectados. O sistema é composto por um **Módulo Mãe** (na raiz) que atua como uma galeria e orquestrador, e **Módulos Filhos** (localizados na pasta `/modules`), que são as aplicações individuais.

## Arquitetura

### Módulo Mãe

O Módulo Mãe é o ponto de entrada principal da aplicação. Ele é responsável por:

1.  **Descobrir Módulos:** Escanear o diretório `/modules` para encontrar todos os projetos (módulos filhos) disponíveis.
2.  **Apresentar a Galeria:** Exibir uma interface de usuário (`index.php` na raiz) que lista todos os módulos encontrados, permitindo que o usuário selecione qual projeto deseja visualizar ou executar.
3.  **Orquestração (Futuro):** No futuro, este módulo poderá ter ferramentas para interagir com módulos que não são baseados na web (como scripts de linha de comando, executáveis, etc.).

### Módulos Filhos

Cada subdiretório dentro da pasta `/modules` é considerado um "Módulo Filho". Cada módulo é um projeto autônomo e deve seguir algumas convenções para ser compatível com o Módulo Mãe.

-   **Estrutura:** Um módulo deve ter uma pasta `public` que sirva como seu ponto de entrada para a web. O Módulo Mãe irá automaticamente criar um link para `modules/{nome_do_modulo}/public/`.
-   **Independência:** Um módulo deve ser o mais independente possível e não depender de outros módulos filhos.
-   **Documentação:** Cada módulo deve conter seu próprio `README.md`, explicando o que o projeto faz, como ele funciona e quaisquer detalhes de configuração específicos.

## Como Adicionar um Novo Módulo

Adicionar um novo projeto à galeria é simples:

1.  **Crie uma Nova Pasta:** Crie um novo diretório dentro da pasta `/modules`. O nome da pasta será usado como o identificador do módulo (ex: `/modules/meu_novo_projeto`).
2.  **Adicione seu Projeto:** Coloque os arquivos do seu projeto dentro da nova pasta que você criou.
3.  **Crie um Ponto de Entrada `public`:** Certifique-se de que seu projeto tenha um diretório `public` que contenha o arquivo de entrada principal (ex: `index.php`, `index.html`).
4.  **Acesse a Galeria:** Abra o `index.php` na raiz do repositório. O seu novo projeto aparecerá automaticamente na galeria.

---
*Este repositório é gerenciado pelo agente de IA Jules.*

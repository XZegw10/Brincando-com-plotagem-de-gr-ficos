#!/bin/bash
# ==============================================================================
# ================ SCRIPT DE SETUP UNIVERSAL (VERSÃO DEFINITIVA) ===============
# ==============================================================================
# INSTRUÇÕES: Este é o template final e corrigido. O conteúdo deste arquivo
# deve ser chamado na interface do Jules com o comando:
# source JULES_SETUP_TEMPLATE.sh
# ==============================================================================

# Saia imediatamente se qualquer comando falhar.
set -e

echo "🚀 Iniciando Setup Universal (Versão Definitiva)..."
echo "   Aplicando as permissões corretas para cada tarefa."
echo "--------------------------------------------------------"


# --- ETAPA 1: DEPENDÊNCIAS DE SISTEMA ESSENCIAIS ---
echo "🔧 [ETAPA 1/5] Instalando dependências de sistema (APT)..."
# [PERMISSÃO CORRETA] Usamos 'sudo' aqui porque 'apt-get' modifica o sistema
# operacional base. É o único local onde privilégios de administrador são necessários.
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    unzip \
    jq \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    composer \
    python3 \
    python3-pip \
    python3-venv

echo "--------------------------------------------------------"


# --- ETAPA 2: CONFIGURAÇÃO DO AMBIENTE NODE.JS (via NVM) ---
# [PERMISSÃO CORRETA] NVM é executado com permissão de usuário, pois gerencia
# o Node.js dentro do diretório 'home' do usuário, sem afetar o sistema.
echo "🟢 [ETAPA 2/5] Configurando ambiente Node.js..."
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
echo "Node.js instalado na versão: $(node -v) via NVM."

echo "--------------------------------------------------------"


# --- ETAPA 3, 4, 5: INSTALAÇÃO DE DEPENDÊNCIAS DE PROJETOS ---
# [PERMISSÃO CORRETA] Comandos de projeto como composer, npm e pip rodam
# SEM 'sudo' para evitar problemas de propriedade de arquivos. Eles operam
# dentro da pasta do seu projeto, que pertence ao usuário normal.

echo "🐘 [ETAPA 3/5] Procurando e instalando dependências PHP..."
find . -name 'composer.json' -not -path '*/vendor/*' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    echo "   -> Encontrado projeto PHP em '$dir'. Instalando dependências..."
    (cd "$dir" && composer install)
done
echo "Dependências PHP instaladas."

echo "--------------------------------------------------------"

echo "📦 [ETAPA 4/5] Procurando e instalando dependências Node.js..."
find . -name 'package.json' -not -path '*/node_modules/*' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    echo "   -> Encontrado projeto Node.js em '$dir'. Instalando dependências..."
    (cd "$dir" && npm ci || npm install)
done
echo "Dependências Node.js instaladas."

echo "--------------------------------------------------------"

echo "🐍 [ETAPA 5/5] Procurando e instalando dependências Python..."
find . -name 'requirements.txt' -not -path '*/venv/*' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    echo "   -> Encontrado projeto Python em '$dir'. Criando venv e instalando..."
    (
        cd "$dir" && \
        python3 -m venv venv && \
        source venv/bin/activate && \
        pip install -r requirements.txt
    )
done
echo "Dependências Python instaladas."

echo "--------------------------------------------------------"
echo "✅✨ Setup Universal concluído! O ambiente está pronto para TUDO, com as permissões corretas."

#!/bin/bash
# ==============================================================================
# ================ SCRIPT DE SETUP UNIVERSAL (VERSÃO DEFINITIVA v4) ==============
# ==============================================================================
# INSTRUÇÕES: Este é o template final e corrigido. O conteúdo deste arquivo
# deve ser chamado na interface do Jules com o comando:
# source JULES_SETUP_TEMPLATE.sh
#
# v4: Feito o "hardcode" da versão do Node.js para evitar falhas de lookup
#     de rede no ambiente de execução. Esta é a abordagem mais robusta.
# ==============================================================================

# Saia imediatamente se qualquer comando falhar.
set -e

echo "🚀 Iniciando Setup Universal (Versão Definitiva v4)..."
echo "   Aplicando as permissões corretas para cada tarefa."
echo "--------------------------------------------------------"


# --- ETAPA 1: DEPENDÊNCIAS DE SISTEMA ESSENCIAIS ---
echo "🔧 [ETAPA 1/5] Instalando dependências de sistema (APT)..."
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
echo "🟢 [ETAPA 2/5] Configurando ambiente Node.js de forma robusta..."
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# [CORREÇÃO v4] Usando uma versão LTS específica para evitar falhas de rede.
# Node.js 22 é a versão LTS ativa em 2025.
HARDCODED_LTS_VERSION="22"

echo "   -> Instalando e usando a versão LTS específica: Node.js ${HARDCODED_LTS_VERSION}"
nvm install "${HARDCODED_LTS_VERSION}"
nvm use "${HARDCODED_LTS_VERSION}"

echo "Node.js instalado na versão: $(node -v)"
echo "NPM instalado na versão: $(npm -v)"


echo "--------------------------------------------------------"


# --- ETAPA 3: INSTALAÇÃO DE DEPENDÊNCIAS PHP (COMPOSER) ---
echo "🐘 [ETAPA 3/5] Procurando e instalando dependências PHP..."
find . -name 'composer.json' -not -path '*/vendor/*' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    echo "   -> Encontrado projeto PHP em '$dir'. Instalando dependências..."
    (cd "$dir" && composer install)
done
echo "Dependências PHP instaladas."

echo "--------------------------------------------------------"

# --- ETAPA 4: INSTALAÇÃO DE DEPENDÊNCIAS NODE.JS (NPM) ---
echo "📦 [ETAPA 4/5] Procurando e instalando dependências Node.js..."
find . -name 'package.json' -not -path '*/node_modules/*' -print0 | while IFS= read -r -d $'\0' file; do
    dir=$(dirname "$file")
    echo "   -> Encontrado projeto Node.js em '$dir'. Instalando dependências..."
    (cd "$dir" && npm ci || npm install)
done
echo "Dependências Node.js instaladas."

echo "--------------------------------------------------------"

# --- ETAPA 5: INSTALAÇÃO DE DEPENDÊNCIAS PYTHON (PIP) ---
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

#!/bin/bash
# ==============================================================================
# ================ TEMPLATE DE SETUP UNIVERSAL PARA JULES AI ===================
# ==============================================================================
# INSTRUÇÕES: Copie e cole TODO o conteúdo deste arquivo na caixa de
# configuração de ambiente da tarefa na interface do Jules.
#
# OBJETIVO: Instala TUDO o que for necessário para TODOS os módulos
# do workspace (PHP, Node.js, Python), criando um ambiente completo.
# ==============================================================================

# Saia imediatamente se qualquer comando falhar.
set -e

echo "🚀 Iniciando Setup Universal..."
echo "   Preparando um ambiente de desenvolvimento completo."
echo "--------------------------------------------------------"


# --- ETAPA 1: DEPENDÊNCIAS DE SISTEMA ESSENCIAIS ---
echo "🔧 [ETAPA 1/5] Instalando dependências de sistema (APT)..."
apt-get update
apt-get install -y \
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
echo "🟢 [ETAPA 2/5] Configurando ambiente Node.js..."
export NVM_DIR="$HOME/.nvm"
# Instala o NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Carrega o NVM para a sessão atual
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Instala e usa a versão LTS (Long-Term Support) mais recente do Node.js
nvm install --lts
nvm use --lts
echo "Node.js instalado na versão: $(node -v) via NVM."

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
echo "✅✨ Setup Universal concluído! O ambiente está pronto para TUDO."

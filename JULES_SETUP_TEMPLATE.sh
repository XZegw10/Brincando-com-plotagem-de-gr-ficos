#!/bin/bash
# ==============================================================================
# ================ SCRIPT DE SETUP UNIVERSAL (VERSÃO DEFINITIVA v5) ==============
# ==============================================================================
# v5: Refatorado para modularidade, adiciona novas ferramentas de produtividade
#     e implementa lógicas de atualização para garantir as versões estáveis
#     mais recentes das dependências críticas.
# ==============================================================================

# --- CONFIGURAÇÃO INICIAL ---
# Saia imediatamente se qualquer comando falhar.
set -e

# --- FUNÇÕES DE LOG ---
log_section() {
    echo "=============================================================================="
    echo "🔵 $1"
    echo "=============================================================================="
}

log_step() {
    echo "   -> $1"
}

# --- FUNÇÕES DE SETUP MODULARES ---

# Gerencia a instalação de PHP e Composer, garantindo a versão mais recente.
setup_php() {
    log_section "CONFIGURANDO AMBIENTE PHP"
    if ! command -v php &> /dev/null; then
        log_step "PHP não encontrado. Instalando a versão estável mais recente via PPA..."
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt-get update
        sudo apt-get install -y php php-cli php-mbstring php-xml composer
    else
        log_step "PHP já está instalado: $(php -v | head -n 1)"
        log_step "Garantindo que o Composer está instalado..."
        sudo apt-get install -y composer
    fi
    log_step "PHP e Composer configurados."
}

# Gerencia a instalação de Node.js via NVM, garantindo a versão LTS mais recente.
setup_node() {
    log_section "CONFIGURANDO AMBIENTE NODE.JS"
    # A documentação do Jules indica que NVM já está disponível.
    # Apenas garantimos que está carregado e usamos a versão LTS mais recente.
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    log_step "Procurando e instalando a versão LTS mais recente do Node.js..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'

    log_step "Node.js ativo: $(node -v)"
    log_step "NPM ativo: $(npm -v)"
}

# Instala novas ferramentas de produtividade e DevOps.
install_dev_tools() {
    log_section "INSTALANDO FERRAMENTAS ADICIONAIS DE PRODUTIVIDADE"

    sudo apt-get update

    # Ferramentas para instalar via APT
    declare -A apt_tools
    apt_tools=(
        [git-lfs]="git-lfs"
        [direnv]="direnv"
        [yq]="yq"
    )

    local tools_to_install=()
    for tool_cmd in "${!apt_tools[@]}"; do
        if ! command -v "$tool_cmd" &> /dev/null; then
            tools_to_install+=("${apt_tools[$tool_cmd]}")
        else
            log_step "✅ $tool_cmd já está instalado."
        fi
    done

    if [ ${#tools_to_install[@]} -gt 0 ]; then
        log_step "Instalando pacotes via APT: ${tools_to_install[*]}"
        sudo apt-get install -y "${tools_to_install[@]}"
    fi

    # Instalação do Pack (Cloud Native Buildpacks)
    if ! command -v pack &> /dev/null; then
        log_step "Instalando 'pack' (Cloud Native Buildpacks)..."
        (
            cd /tmp && \
            curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.34.1/pack-v0.34.1-linux.tgz" | sudo tar -xz -C /usr/local/bin
        )
    else
        log_step "✅ pack já está instalado."
    fi

    # Instalação do toml-cli (via Cargo)
    if ! command -v toml &> /dev/null; then
        log_step "Instalando 'toml-cli' (via Cargo)..."
        cargo install toml-cli
    else
        log_step "✅ toml-cli (toml) já está instalado."
    fi

    log_step "Novas ferramentas de produtividade configuradas."
}

# Instala dependências de projetos encontrados no repositório.
install_project_dependencies() {
    log_section "INSTALANDO DEPENDÊNCIAS DE PROJETOS"

    # PHP (Composer)
    find . -name 'composer.json' -not -path '*/vendor/*' -print0 | while IFS= read -r -d $'\0' file; do
        dir=$(dirname "$file")
        log_step "🐘 Encontrado projeto PHP em '$dir'. Instalando com Composer..."
        (cd "$dir" && composer install --no-interaction --no-progress)
    done

    # Node.js (NPM)
    find . -name 'package.json' -not -path '*/node_modules/*' -print0 | while IFS= read -r -d $'\0' file; do
        dir=$(dirname "$file")
        log_step "📦 Encontrado projeto Node.js em '$dir'. Instalando com NPM..."
        (cd "$dir" && npm ci || npm install)
    done

    # Python (Pip)
    find . -name 'requirements.txt' -not -path '*/venv/*' -print0 | while IFS= read -r -d $'\0' file; do
        dir=$(dirname "$file")
        log_step "🐍 Encontrado projeto Python em '$dir'. Instalando com Pip..."
        (
            cd "$dir" && \
            python3 -m venv venv && \
            source venv/bin/activate && \
            pip install -r requirements.txt
        )
    done

    log_step "Dependências de projetos instaladas."
}

# --- EXECUÇÃO PRINCIPAL DO SCRIPT ---

main() {
    echo "🚀 Iniciando Setup Universal (Versão Definitiva v5)..."

    setup_php
    setup_node
    install_dev_tools
    install_project_dependencies

    echo "=============================================================================="
    echo "✅✨ Setup Universal concluído! O ambiente está pronto para TUDO."
    echo "=============================================================================="
}

# Executa a função principal.
main

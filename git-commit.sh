#!/bin/bash

# Smart Git Commit Script - Curral Tech
# Resolve problemas de lock do Git e automatiza add/commit/push

set -e

# ══════════════════════════════════════════════════════════════
# PALETA DE CORES (256-color)
# ══════════════════════════════════════════════════════════════

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Cores vibrantes (256-color)
RED="\033[38;5;203m"
RED_BRIGHT="\033[38;5;196m"
GREEN="\033[38;5;114m"
GREEN_BRIGHT="\033[38;5;46m"
YELLOW="\033[38;5;221m"
BLUE="\033[38;5;75m"
BLUE_BRIGHT="\033[38;5;39m"
CYAN="\033[38;5;80m"
ORANGE="\033[38;5;215m"
PURPLE="\033[38;5;141m"

# Tons neutros
WHITE="\033[38;5;255m"
GRAY_LIGHT="\033[38;5;252m"
GRAY="\033[38;5;246m"
GRAY_DARK="\033[38;5;240m"

# Backgrounds
BG_RED="\033[48;5;52m"
BG_GREEN="\033[48;5;22m"
BG_BLUE="\033[48;5;17m"

# ══════════════════════════════════════════════════════════════
# BOX DRAWING CHARACTERS (Unicode)
# ══════════════════════════════════════════════════════════════

# Linhas simples
H_LINE="─"
V_LINE="│"
TL_CORNER="┌"
TR_CORNER="┐"
BL_CORNER="└"
BR_CORNER="┘"

# Linhas arredondadas
TL_ROUND="╭"
TR_ROUND="╮"
BL_ROUND="╰"
BR_ROUND="╯"

# Timeline symbols
TL_NODE="●"
TL_NODE_SUCCESS="◉"
TL_NODE_ERROR="◈"
TL_CONTINUE="│"
TL_BRANCH="├"
TL_END="└"

# Símbolos
ARROW_RIGHT="▶"
BULLET="●"
CHECK="✓"
CROSS_MARK="✗"

# ══════════════════════════════════════════════════════════════
# FUNÇÕES
# ══════════════════════════════════════════════════════════════

show_help() {
    echo ""
    echo -e "${BLUE}${TL_ROUND}${H_LINE}${H_LINE} ${BOLD}Smart Git Commit Script${RESET}${BLUE} ${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${TR_ROUND}${RESET}"
    echo ""
    echo -e "${GRAY_LIGHT}Uso:${RESET}"
    echo -e "  ${WHITE}./git-commit.sh \"mensagem do commit\"${RESET}"
    echo ""
    echo -e "${GRAY_LIGHT}Exemplo:${RESET}"
    echo -e "  ${WHITE}./git-commit.sh \"fix: corrige bug no login\"${RESET}"
    echo ""
    echo -e "${GRAY_LIGHT}O script automaticamente:${RESET}"
    echo -e "  ${GRAY_DARK}${TL_BRANCH}${RESET} ${GRAY_LIGHT}Remove lock file do Git (se existir)${RESET}"
    echo -e "  ${GRAY_DARK}${TL_BRANCH}${RESET} ${GRAY_LIGHT}Adiciona todos os arquivos (git add .)${RESET}"
    echo -e "  ${GRAY_DARK}${TL_BRANCH}${RESET} ${GRAY_LIGHT}Cria o commit com a mensagem fornecida${RESET}"
    echo -e "  ${GRAY_DARK}${TL_END}${RESET} ${GRAY_LIGHT}Faz push para a branch atual${RESET}"
    echo ""
    echo -e "${BLUE}${BL_ROUND}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${BR_ROUND}${RESET}"
    echo ""
}

print_error() {
    echo -e "${GRAY_DARK}  ${TL_CONTINUE}${RESET}"
    echo -e "${RED_BRIGHT}  ${TL_NODE_ERROR}${H_LINE}${RESET}${BG_RED}${WHITE}${BOLD} ERRO ${RESET}"
    echo -e "${GRAY_DARK}  ${TL_CONTINUE}${RESET} ${RED}$1${RESET}"
}

print_success() {
    echo -e "${GREEN_BRIGHT}  ${TL_NODE_SUCCESS}${H_LINE}${CHECK} ${RESET}${GREEN}$1${RESET}"
}

print_info() {
    echo -e "${GRAY_DARK}  ${TL_BRANCH}${H_LINE}${RESET}${GRAY_LIGHT}${BULLET} $1${RESET}"
}

print_step() {
    echo -e "${BLUE}  ${TL_NODE}${H_LINE}${ARROW_RIGHT} ${BOLD}$1${RESET}"
}

# ══════════════════════════════════════════════════════════════
# VALIDAÇÕES
# ══════════════════════════════════════════════════════════════

# Verifica se mensagem foi fornecida
if [ -z "$1" ]; then
    print_error "Mensagem do commit nao fornecida"
    show_help
    exit 1
fi

# Captura mensagem do commit
COMMIT_MSG="$1"

# Verifica se estamos em um repositório Git
if [ ! -d .git ]; then
    print_error "Nao estamos em um repositorio Git"
    exit 1
fi

# ══════════════════════════════════════════════════════════════
# EXECUÇÃO
# ══════════════════════════════════════════════════════════════

echo ""
echo -e "${CYAN}${TL_ROUND}${H_LINE}${H_LINE} ${BOLD}Git Commit & Push${RESET}${CYAN} ${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${TR_ROUND}${RESET}"
echo ""

# Identifica branch atual
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
print_info "Branch: ${PURPLE}${CURRENT_BRANCH}${RESET}"

# Remove lock file se existir
if [ -f .git/index.lock ]; then
    print_info "Removendo lock file..."
    rm -f .git/index.lock
fi

# Pequeno delay para evitar race conditions
sleep 1

# Git add
echo ""
print_step "Adicionando arquivos..."
git add .

# Pequeno delay antes do commit
sleep 2

# Git commit
echo ""
print_step "Criando commit..."
git commit -m "$COMMIT_MSG"

# Verifica se commit foi bem sucedido
if [ $? -eq 0 ]; then
    echo ""
    print_success "Commit criado com sucesso"

    # Git push
    echo ""
    print_step "Enviando para origin/${CURRENT_BRANCH}..."
    git push

    if [ $? -eq 0 ]; then
        echo ""
        print_success "Push concluido"

        # Status final
        echo ""
        echo -e "${GRAY_DARK}  ${TL_CONTINUE}${RESET}"
        echo -e "${PURPLE}  ${TL_NODE}${H_LINE}${BOLD} Status final${RESET}"
        echo -e "${GRAY_DARK}  ${TL_CONTINUE}${RESET}"

        # Captura e formata git status
        git status --short | while IFS= read -r line; do
            echo -e "${GRAY_DARK}  ${TL_BRANCH}${RESET} ${GRAY_LIGHT}$line${RESET}"
        done

        # Se não há mudanças
        if [ -z "$(git status --short)" ]; then
            echo -e "${GRAY_DARK}  ${TL_END}${RESET} ${GREEN}Working tree clean${RESET}"
        fi

        echo ""
        echo -e "${CYAN}${BL_ROUND}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${H_LINE}${BR_ROUND}${RESET}"
        echo ""
    else
        print_error "Falha no push"
        exit 1
    fi
else
    print_error "Falha no commit"
    exit 1
fi

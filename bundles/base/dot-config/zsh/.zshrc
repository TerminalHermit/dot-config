#!/usr/bin/env zsh

ZSHRC_DIR="${0:A:h}"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# INSTALLER
#

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

export TPM_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/tmux/tpm.git"
if [ ! -d "$TPM_HOME" ]; then
   mkdir -p "$(dirname $TPM_HOME)"
   git clone https://github.com/tmux-plugins/tpm.git "$TPM_HOME"
fi

#Plugins
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit wait lucid for MichaelAquilina/zsh-autoswitch-virtualenv

#Snippets
zinit snippet OMZP::git
zinit snippet OMZP::procs
zinit snippet OMZP::kubectl
zinit snippet OMZP::dotenv
zinit snippet OMZP::command-not-found

# completions
autoload -Uz compinit && compinit
zinit cdreplay -q
[[ ! -f "$ZSHRC_DIR/.p10k.zsh" ]] || source "$ZSHRC_DIR/.p10k.zsh"


#Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
SAVEHIST=42000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
while IFS='=' read -r alias command; do 
  if [[ -n $alias && -n $command ]]; then
    alias $alias=$command
    echo "Alias created: $alias='$command'"
  fi
done < "$ZSHRC_DIR/alias"

# Shell integrations
if command -v fzf > /dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi

if command -v kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
fi
#─────────────────────────────#
#  Zig-zag fast prompt (P10k) #
#─────────────────────────────#
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet   # suprime warning si hay output

#─────────────────────────────#
#  Rutas XDG                  #
#─────────────────────────────#
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

#─────────────────────────────#
#  Oh-My-Zsh + tema           #
#─────────────────────────────#
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  z                       # cd rápido
  fzf                     # búsqueda interactiva
  sudo
  copyfile
  web-search
  history-substring-search
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  rbenv
  pyenv
)

source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#─────────────────────────────#
#  PATH                       #
#─────────────────────────────#
path=("$HOME/.local/bin" $path)

#─────────────────────────────#
#  Historial                  #
#─────────────────────────────#
HISTFILE=$XDG_DATA_HOME/zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history inc_append_history share_history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#─────────────────────────────#
#  Opciones de shell útiles   #
#─────────────────────────────#
setopt autocd pushd_ignore_dups globdots numericglobsort interactivecomments

#─────────────────────────────#
#  Alias                      #
#─────────────────────────────#
alias ll='ls -alFh --color=auto'
alias cat='bat --style=plain --paging=never'
alias grep='grep --color=auto'
alias please='sudo'
alias g='git'
alias gs='git status -sb'
alias gp='git pull --prune'
alias lg='lazygit'

# Timer rápido: t 5m "Break"
t() { sleep "${1:-1m}" && notify-send "${2:-Time}" || echo "Uso: t <1m|30s> <msg>"; }

#─────────────────────────────#
#  fzf completions            #
#─────────────────────────────#
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi

#─────────────────────────────#
#  Version managers           #
#─────────────────────────────#
command -v rbenv >/dev/null && eval "$(rbenv init - zsh 2>/dev/null)"
command -v pyenv >/dev/null && eval "$(pyenv init - --no-rehash zsh 2>/dev/null)"

#─────────────────────────────#
#  Prompt ligero en SSH       #
#─────────────────────────────#
[[ -n "$SSH_CONNECTION" ]] && export DISABLE_UNTRACKED_FILES_DIRTY=truetypeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

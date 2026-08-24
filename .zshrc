[[ -o interactive ]] || return

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INTERACTIVE_COMMENTS
unsetopt BEEP

autoload -Uz compinit colors
colors
zmodload zsh/complist
compinit -d "$HOME/.cache/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'

bindkey -e
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[C' forward-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(dircolors -b)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(starship init zsh)"

alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lah --icons=auto --group-directories-first --git'
alias la='eza -a --icons=auto --group-directories-first'
alias tree='eza --tree --icons=auto'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias rg='rg --smart-case'
alias fd='fd --hidden --exclude .git'
alias vim='nvim'
alias vi='nvim'
alias update='sudo pacman -Syu'

export PATH="$HOME/.local/bin:$PATH"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Give each local Kitty process its own tmux workspace so separate terminal
# windows stay independent while retaining pane navigation and copy-mode keys.
if [[ -n ${KITTY_PID:-} && -z ${TMUX:-} && -z ${SSH_CONNECTION:-} ]]; then
    tmux new-session -A -s "kitty-${KITTY_PID}" \; set-option destroy-unattached on
fi

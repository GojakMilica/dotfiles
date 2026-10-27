#
# ~/.zshrc
#

# Okruženje
typeset -U path
path=("$HOME/.local/bin" $path)
export PATH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# Boje za newt TUI (nmtui i sl.): ANSI imena koja kitty mapira na paletu,
# "default" znači providna pozadina terminala
export NEWT_COLORS='root=white,default;border=magenta,default;window=lightgray,default;shadow=default,default;title=brightmagenta,default;button=black,magenta;actbutton=black,brightmagenta;compactbutton=lightgray,default;checkbox=lightgray,default;actcheckbox=black,brightmagenta;entry=white,default;disentry=gray,default;label=lightgray,default;listbox=lightgray,default;actlistbox=black,magenta;sellistbox=brightmagenta,default;actsellistbox=black,brightmagenta;textbox=lightgray,default;acttextbox=black,magenta;helpline=gray,default;roottext=gray,default'

# Aliasi
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Istorija (deljena između terminala)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Dopunjavanje (meni sa strelicama, case-insensitive)
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Pluginovi (syntax-highlighting mora poslednji)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt
eval "$(starship init zsh)"

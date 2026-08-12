## history
# zsh saves nothing unless HISTFILE is set.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY APPEND_HISTORY

## completion
# Both must run before interactive.sh. The gcloud zsh completion it sources
# needs compinit; nvm ships a bash completion only, and the `complete` builtin
# that file calls does not exist in zsh without bashcompinit. gcloud's
# completion.zsh.inc happens to load bashcompinit itself, so loading it here is
# what stops nvm's completion depending on gcloud being installed.
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

## shared config (stow package: shell)
[ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"
[ -f "$HOME/.config/shell/interactive.sh" ] && . "$HOME/.config/shell/interactive.sh"

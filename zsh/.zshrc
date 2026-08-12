## history
# zsh saves nothing unless HISTFILE is set.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY APPEND_HISTORY

## completion
# Must run before common.sh: the gcloud zsh completion it sources needs compinit.
autoload -Uz compinit && compinit

## shared config (stow package: shell)
[ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.

## shared environment (stow package: shell)
[ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"

## bash login shells
# If running bash, source ~/.bashrc so interactive login shells get prompt,
# completions and aliases. (Non-interactive shells return early inside ~/.bashrc).
if [ -n "${BASH_VERSION:-}" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

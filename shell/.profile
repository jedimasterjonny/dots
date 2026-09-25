# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.

# openSUSE's /etc/profile sources ~/.bashrc itself, before bash reads this
# file, and sets _HOMEBASHRC readonly as it does (its own loop detection).
# Debian leaves both to this file, which is why it carries the block below.
# Without the guard a SUSE login shell reads common.sh three times and
# interactive.sh twice: direnv, fzf and gcloud all hook themselves twice.
if [ -z "${_HOMEBASHRC:-}" ]; then

  ## shared environment (stow package: shell)
  [ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"

  ## bash login shells
  # sh login shells stop at common.sh above; bash wants the prompt, the
  # completions and the aliases too. (~/.bashrc returns early when it is not
  # interactive.)
  if [ -n "${BASH_VERSION:-}" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi

fi

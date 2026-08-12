# Interactive-only shell config, sourced by ~/.bashrc and ~/.zshrc.
# Keep this POSIX sh: it is read by both bash and zsh.
#
# Split out of common.sh so each rc file can source it *after* its distro's own
# setup — Debian's ~/.bashrc defines aliases and PS1 unconditionally, so anything
# defined here has to come later to survive.
#
# Self-gating rather than relying on the caller: bash is built with
# SSH_SOURCE_BASHRC on openSUSE and reads ~/.bashrc for a non-interactive
# `ssh host 'cmd'`, and bash-suse carries no interactive guard of its own. None
# of this belongs in a remote command, and printing anything there would corrupt
# the stream scp and rsync parse as their own protocol.
#
# No test needed for zsh: it reads ~/.zshrc for interactive shells only, so
# arriving here by way of zsh already means interactive.

if [ -n "${ZSH_VERSION:-}" ]; then
  _shell=zsh
else
  case $- in
    *i*) _shell=bash ;;
    *) return 0 ;;
  esac
fi

## gcloud completion
if [ -s "$HOME/google-cloud-sdk/completion.$_shell.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.$_shell.inc"
fi

## nvm completion
# nvm ships a bash completion only, so unlike gcloud above there is no zsh
# variant to select. It calls `complete`, which zsh provides through bashcompinit
# — loaded by ~/.zshrc before this file, alongside compinit.
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]; then
  . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

## direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook "$_shell")"
fi

## local aliases
[ -f "$HOME/goog-aliases" ] && . "$HOME/goog-aliases"

unset _shell

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

## fzf
# All of it interactive-only, unlike ripgrep's half of the same pair in
# common.sh: fzf is a full-screen picker, so neither its defaults nor its key
# bindings mean anything to `ssh host 'cmd'`.
_fzf_opts="${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzfrc"
if [ -f "$_fzf_opts" ]; then
  export FZF_DEFAULT_OPTS_FILE="$_fzf_opts"
fi
unset _fzf_opts

if command -v fzf >/dev/null 2>&1; then
  # Send a bare `fzf` through rg for the one thing fzf's own walker cannot do:
  # the walker skips .git and node_modules by name but reads no .gitignore, so
  # build output and vendored trees come back with everything else.
  #
  # FZF_DEFAULT_COMMAND only, deliberately — leaving FZF_CTRL_T_COMMAND unset
  # keeps CTRL-T on that walker, which offers directories and reaches
  # gitignored-but-wanted files like .env, neither of which `rg --files` lists.
  if command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files'
  fi

  # Key bindings and completion in one call, which needs fzf 0.48 or newer —
  # before that the two shipped as separate scripts under the install prefix,
  # and this prints an unknown-option error instead.
  eval "$(fzf --"$_shell")"
fi

## local aliases
[ -f "$HOME/goog-aliases" ] && . "$HOME/goog-aliases"

unset _shell

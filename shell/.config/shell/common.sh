# Shared shell config, sourced by ~/.bashrc and ~/.zshrc.
# Keep this POSIX sh: it is read by both bash and zsh.
#
# Environment only — PATH, EDITOR and the tools that populate them — so that a
# non-interactive `ssh host 'cmd'` can source this and get the same PATH it would
# get at a prompt. Everything that shapes a session rather than the environment
# lives in interactive.sh, which each rc file sources later on.

if [ -n "${ZSH_VERSION:-}" ]; then
  _shell=zsh
else
  _shell=bash
fi

## brew
# Before the path block below: brew's shellenv prepends its own bin dir, so
# running it first leaves the personal dirs ahead of brew-installed tools.
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv "$_shell")"
fi
export HOMEBREW_NO_ENV_HINTS=1

## path
# Listed lowest-priority first; each is prepended, so the last one wins.
#
# Each dir is stripped from PATH and re-prepended rather than skipped when
# already present. Skipping only holds the order on a shell's first pass: source
# this file again — a nested shell, `exec bash`, a new tmux pane — and brew's
# shellenv would prepend itself a second time while these dirs, already present,
# were left where they were, quietly putting brew back in front.
for _dir in "$HOME/.local/bin" "$HOME/.antigravity/antigravity/bin" "$HOME/jonnyoc-bin"; do
  [ -d "$_dir" ] || continue
  _path=":$PATH:"
  while :; do
    case "$_path" in
      *":$_dir:"*) _path="${_path%%":$_dir:"*}:${_path#*":$_dir:"}" ;;
      *) break ;;
    esac
  done
  _path="${_path#:}"
  _path="${_path%:}"
  # An empty element means "current directory" to the shell, so never leave one.
  if [ -n "$_path" ]; then
    PATH="$_dir:$_path"
  else
    PATH="$_dir"
  fi
done
export PATH
unset _dir _path

## editor
# After the path block above, not before it: probing for nvim any earlier misses
# one installed by brew or dropped in ~/.local/bin, and silently settles for vim
# while nvim is on PATH by the time the file finishes.
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

## gcloud
# Path half only — it puts gcloud on PATH, so a remote `ssh host 'gcloud …'`
# needs it. The completions are interactive-only and live in interactive.sh.
if [ -s "$HOME/google-cloud-sdk/path.$_shell.inc" ]; then
  . "$HOME/google-cloud-sdk/path.$_shell.inc"
fi

## nvm
# Same split: nvm.sh is what puts node on PATH, its completions are not.
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -d "$HOMEBREW_PREFIX/opt/nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi

## npm global bin
# Outside the nvm block above: node may equally come from brew or the distro,
# and global installs are just as invisible then.
if command -v npm >/dev/null 2>&1; then
  # Cache npm prefix to avoid a slow npm call on every shell start. Keyed by
  # node version: nvm switches change the prefix, and a single cache file would
  # pin PATH to whichever version happened to be current when it was written.
  _node_ver=$(node --version 2>/dev/null || echo none)
  _npm_prefix_cache="${XDG_CACHE_HOME:-$HOME/.cache}/npm_global_prefix.$_node_ver"
  # -s, not -f: a failed npm call leaves an empty file behind, and testing for
  # mere existence would cache that failure for the life of the node version.
  if [ ! -s "$_npm_prefix_cache" ]; then
    mkdir -p "$(dirname "$_npm_prefix_cache")"
    npm config --global get prefix > "$_npm_prefix_cache" 2>/dev/null
  fi
  _npm_prefix=$(cat "$_npm_prefix_cache" 2>/dev/null)
  # Executables live in $prefix/bin, not $prefix itself.
  if [ -n "$_npm_prefix" ] && [ -d "$_npm_prefix/bin" ]; then
    case ":$PATH:" in
      *":$_npm_prefix/bin:"*) ;;
      *) PATH="$PATH:$_npm_prefix/bin" ;;
    esac
    export PATH
  fi
  unset _node_ver _npm_prefix_cache _npm_prefix
fi

unset _shell

# Shared shell config, sourced by ~/.bashrc and ~/.zshrc.
# Keep this POSIX sh: it is read by both bash and zsh.

if [ -n "${ZSH_VERSION:-}" ]; then
  _shell=zsh
else
  _shell=bash
fi

## editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

## path
# Listed lowest-priority first; each is prepended, so the last one wins.
for _dir in "$HOME/.local/bin" "$HOME/.antigravity/antigravity/bin" "$HOME/jonnyoc-bin"; do
  if [ -d "$_dir" ]; then
    PATH="$_dir:$PATH"
  fi
done
export PATH
unset _dir

## brew
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv "$_shell")"
fi
export HOMEBREW_NO_ENV_HINTS=1

## gcloud
if [ -d "$HOME/google-cloud-sdk" ]; then
  [ -s "$HOME/google-cloud-sdk/path.$_shell.inc" ] && . "$HOME/google-cloud-sdk/path.$_shell.inc"
  [ -s "$HOME/google-cloud-sdk/completion.$_shell.inc" ] && . "$HOME/google-cloud-sdk/completion.$_shell.inc"
fi

## nvm
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -d "$HOMEBREW_PREFIX/opt/nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

  # Cache npm prefix to avoid a slow npm call on every shell start
  _npm_prefix_cache="${XDG_CACHE_HOME:-$HOME/.cache}/npm_global_prefix"
  if [ ! -f "$_npm_prefix_cache" ]; then
    mkdir -p "$(dirname "$_npm_prefix_cache")"
    npm config --global get prefix > "$_npm_prefix_cache" 2>/dev/null
  fi
  _npm_prefix=$(cat "$_npm_prefix_cache" 2>/dev/null)
  if [ -n "$_npm_prefix" ]; then
    export PATH="$PATH:$_npm_prefix"
  fi
  unset _npm_prefix_cache _npm_prefix
fi

## direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook "$_shell")"
fi

## local aliases
[ -f "$HOME/goog-aliases" ] && . "$HOME/goog-aliases"

unset _shell


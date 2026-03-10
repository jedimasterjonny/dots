## gcloud
if [ -d "$HOME/google-cloud-sdk" ]; then
  [ -s "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
  [ -s "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

## brew
if [[ "$(uname)" == "Linux" && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi
export HOMEBREW_NO_ENV_HINTS=1

## nvm
if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

  # Cache npm prefix to avoid slow npm call on every shell start
  _npm_prefix_cache="${XDG_CACHE_HOME:-$HOME/.cache}/npm_global_prefix"
  if [ ! -f "$_npm_prefix_cache" ]; then
    mkdir -p "$(dirname "$_npm_prefix_cache")"
    npm config --global get prefix > "$_npm_prefix_cache" 2>/dev/null
  fi
  npm_prefix=$(cat "$_npm_prefix_cache" 2>/dev/null)
  if [ -n "$npm_prefix" ]; then
    export PATH="$PATH:$npm_prefix"
  fi
  unset _npm_prefix_cache npm_prefix
fi

## antigravity
if [ -d "$HOME/.antigravity/antigravity/bin" ]; then
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

if [ -d "$HOME/jonnyoc-bin" ]; then
  export PATH="$HOME/jonnyoc-bin:$PATH"
fi

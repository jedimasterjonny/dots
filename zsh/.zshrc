## gcloud
if [ -d "$HOME/google-cloud-sdk" ]; then
  [ -s "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
  [ -s "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

## nvm
if [ -d "$HOMEBREW_PREFIX/opt/nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

  npm_prefix=$(npm config --global get prefix)
  if [ -n "$npm_prefix" ]; then
    export PATH="$PATH:$npm_prefix"
  fi
fi

## antigravity
if [ -d "$HOME/.antigravity/antigravity/bin" ]; then
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

if [ -d "$HOME/jonnyoc-bin" ]; then
  export PATH="$HOME/jonnyoc-bin:$PATH"
fi

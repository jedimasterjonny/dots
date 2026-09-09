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
#
# The prefix differs per platform, so probe for it rather than hardcode one:
# linuxbrew on the distros, /opt/homebrew on Apple Silicon, /usr/local on Intel
# Macs. Most specific first: an Apple Silicon Mac can carry a second, Rosetta
# brew under /usr/local, and the native prefix should win.
#
# On macOS this block is doing more than it is on Linux. Homebrew's installer
# drops /etc/paths.d/homebrew, so brew lands on PATH with no shell config at
# all — but path_helper appends that entry *after* the system dirs, the reverse
# of what shellenv does, leaving a brew-installed git or curl losing to the one
# in /usr/bin. Running shellenv is what puts brew back in front, and what sets
# HOMEBREW_PREFIX, which the python and nvm blocks below are gated on and which
# nothing else on a Mac exports.
#
# The fallback assignment is not redundant. shellenv prints nothing at all when
# its bin and sbin are already the first two entries of PATH, so a shell that
# inherited brew's PATH without its variables — an editor terminal, a CI runner
# — would otherwise leave HOMEBREW_PREFIX unset and silently skip both of those
# blocks while brew itself worked fine.
for _brew in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$_brew" ] || continue
  eval "$("$_brew" shellenv "$_shell")"
  [ -n "${HOMEBREW_PREFIX:-}" ] || export HOMEBREW_PREFIX="${_brew%/bin/brew}"
  break
done
unset _brew
export HOMEBREW_NO_ENV_HINTS=1

## nvm
# Same split: nvm.sh is what puts node on PATH, its completions are not.
#
# Before the path block rather than after it, so that the bin dir can join the
# list there. nvm.sh re-activates the current version on every source, but
# nvm_change_path substitutes its entry in place instead of re-prepending it,
# deliberately, to preserve the order PATH already had. So node cannot defend
# its position on a second pass, while brew's shellenv hoists itself back to the
# front every time it is not already there — a nested shell, `exec bash`, a new
# tmux pane — and a brew-installed node would quietly start outranking the
# selected version. Running nvm here lets the loop below re-anchor it like every
# other dir.
#
# The bin dir is captured here rather than read from the environment down in the
# loop, so that the entry follows from this file having run nvm rather than from
# whatever a parent process happened to export.
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -d "$HOMEBREW_PREFIX/opt/nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  # brew's nvm.sh creates ~/.nvm as it loads and dies where it cannot — an
  # unwritable HOME, a daemon account. `set -e` propagates into a sourced file,
  # so under one that failure aborts the caller here and takes everything below
  # with it: no PATH block, no EDITOR, no ripgrep. Chaining `|| true` onto the
  # source does not help, because nvm.sh dies partway rather than returning
  # non-zero. Dropping -e around it, and restoring it only if it was set, is
  # what actually contains the failure.
  if [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
    case $- in
      *e*) _nvm_e=1; set +e ;;
      *)   _nvm_e= ;;
    esac
    . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    [ -z "$_nvm_e" ] || set -e
    unset _nvm_e
  fi
  _nvm_bin="${NVM_BIN:-}"
fi

## path
# Listed lowest-priority first; each is prepended, so the last one wins.
#
# Each dir is stripped from PATH and re-prepended rather than skipped when
# already present. Skipping only holds the order on a shell's first pass: source
# this file again — a nested shell, `exec bash`, a new tmux pane — and brew's
# shellenv would prepend itself a second time while these dirs, already present,
# were left where they were, quietly putting brew back in front.
# The brew entry is python's unversioned symlinks — `python`, `pip`, `idle` —
# which the formula keeps out of its own bin dir on purpose, so that installing
# python cannot quietly become the `python` a script picks up. Nothing else
# provides a bare `python` on macOS. Named through the `opt/python` alias rather
# than `opt/python@3.14`: brew repoints that symlink on a major upgrade, so a
# later 3.15 needs no edit here. Written with :+ rather than :-, so a machine
# with no brew contributes an empty element that the -d test below drops; :-
# would leave a bare /opt/python/libexec/bin, which is a real path on some
# vendor and CI images.
#
# The node entry is the active version's bin dir, captured in the nvm block just
# above. Re-prepended here rather than left where nvm.sh put it, so that it
# holds its place across a re-source; empty, and skipped, when no version is
# selected. Below the personal dirs on purpose: a node or npm wrapper dropped in
# one of those is meant to win, as it would for any other tool.
for _dir in "${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/python/libexec/bin}" "${_nvm_bin:-}" "$HOME/.local/bin" "$HOME/.antigravity/antigravity/bin" "$HOME/jonnyoc-bin"; do
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
unset _dir _path _nvm_bin

## editor
# After the path block above, not before it: probing for nvim any earlier misses
# one installed by brew or dropped in ~/.local/bin, and silently settles for vim
# while nvim is on PATH by the time the file finishes.
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

## ripgrep
# ripgrep reads no config file unless RIPGREP_CONFIG_PATH names one, so the
# ripgrep package does nothing without this. Here rather than in
# interactive.sh because `ssh host 'rg …'` is as ordinary as rg at a prompt,
# and the two should search by the same rules.
#
# Guarded on the file, unlike the other blocks here, for a reason beyond
# tidiness: pointing the variable at a path that does not exist makes every
# single rg invocation print a "failed to read the file" error, so a machine
# without the package stowed is better off with it unset.
_rg_config="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/ripgreprc"
if [ -f "$_rg_config" ]; then
  export RIPGREP_CONFIG_PATH="$_rg_config"
fi
unset _rg_config

## gcloud
# Path half only — it puts gcloud on PATH, so a remote `ssh host 'gcloud …'`
# needs it. The completions are interactive-only and live in interactive.sh.
if [ -s "$HOME/google-cloud-sdk/path.$_shell.inc" ]; then
  . "$HOME/google-cloud-sdk/path.$_shell.inc"
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

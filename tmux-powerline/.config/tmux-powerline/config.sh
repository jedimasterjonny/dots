# tmux-powerline configuration: only the settings that differ from upstream.
#
# tmux-powerline sources config/defaults.sh before this file and fills in the
# general settings left unset; the segments themselves default the rest, each
# reading its own `${TMUX_POWERLINE_SEG_…:-default}`. Vendoring the full 542-line
# generated config therefore buys nothing — and costs something: generate_config.sh
# bakes absolute $HOME paths into a dozen settings, which is how a workstation
# path once reached this public repo.
#
# `~/.tmux/plugins/tmux-powerline/generate_config.sh` writes every available
# setting and its default to config.sh.default for reference. It does not write
# this file.

# The theme lives in this same stow package, in themes/bubble.sh. Upstream ships
# a bubble theme of its own with frappe accents, so the two directory settings
# below are what select ours over it — and unlike the settings above them they
# have no entry in defaults.sh, so omitting them silently falls back to upstream.
export TMUX_POWERLINE_THEME="bubble"
export TMUX_POWERLINE_DIR_USER_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"
export TMUX_POWERLINE_DIR_USER_SEGMENTS="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/segments"

# Wider than the 60-column default; the left side carries hostname, load and branch.
export TMUX_POWERLINE_STATUS_LEFT_LENGTH="90"

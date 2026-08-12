# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

test -s ~/.alias && . ~/.alias || true

## history
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=50000
shopt -s histappend

## shared config (stow package: shell)
# interactive.sh comes last, after ~/.alias above, so its aliases win. It gates
# itself on $-, which matters here: this file has no non-interactive guard, and
# bash reads it for `ssh host 'cmd'` too.
[ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"
[ -f "$HOME/.config/shell/interactive.sh" ] && . "$HOME/.config/shell/interactive.sh"

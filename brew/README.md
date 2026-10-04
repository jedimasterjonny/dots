# brew

The formulae and casks this Mac runs, each under the one-line description
`brew bundle dump --describe` writes. Those comments are regenerated on every dump, so
anything said about the file itself lives here rather than in it.

Stowing installs nothing; `brew bundle` does that. It finds `~/Brewfile` only when run
from `~` — anywhere else, pass `--file ~/Brewfile`. `--global` looks for `~/.Brewfile`
instead and will not see this one.

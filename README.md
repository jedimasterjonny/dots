# dots

Personal dotfiles for openSUSE, Ubuntu and macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package mirroring `$HOME`. Stowing one symlinks its
files into place; `stow -D` removes them. No package installs the tool it configures.

Rationale lives with the thing it explains — as comments in the config files themselves,
and in a `README.md` in the few packages that need more than a comment can carry. Those
are linked from the table below.

## Packages

| Package                              | Installs                                                       | Needs   |
| ------------------------------------ | -------------------------------------------------------------- | ------- |
| `shell`                              | `~/.config/shell/{common,interactive}.sh`, `~/.profile`        |         |
| `bash-suse`                          | `~/.bashrc` for openSUSE                                       | `shell` |
| `bash-ubuntu`                        | `~/.bashrc` for Ubuntu/Debian                                  | `shell` |
| `zsh`                                | `~/.zshrc`                                                     | `shell` |
| `readline`                           | `~/.inputrc`                                                   |         |
| `git`                                | `~/.gitconfig`, `~/.config/git/ignore`                         |         |
| `ssh`                                | `~/.ssh/config`                                                |         |
| `gh`                                 | `~/.config/gh/config.yml`                                      |         |
| `ripgrep`                            | `~/.config/ripgrep/ripgreprc`                                  | `shell` |
| `fzf`                                | `~/.config/fzf/fzfrc`                                          | `shell` |
| [`nvim`](nvim/README.md)             | [LazyVim](https://www.lazyvim.org/) config in `~/.config/nvim` |         |
| `code`                               | VS Code `settings.json` (Linux path only)                      |         |
| [`code-macos`](code-macos/README.md) | Same `settings.json`, macOS path                               |         |
| [`ghostty`](ghostty/README.md)       | `~/.config/ghostty/config`                                     |         |
| [`tmux`](tmux/README.md)             | `~/.tmux.conf`                                                 | tpm     |
| `tmux-powerline`                     | `~/.config/tmux-powerline/config.sh`                           | tpm     |
| `herdr`                              | `~/.config/herdr/config.toml`                                  |         |

## Install

```sh
git clone git@github.com:jedimasterjonny/dots.git ~/dots
cd ~/dots
stow shell readline git ssh gh ripgrep fzf nvim code ghostty tmux tmux-powerline herdr
stow bash-suse  # or bash-ubuntu, and/or zsh
```

On macOS, swap `code` for `code-macos` — `code` installs the Linux path,
`~/.config/Code/User/`, which VS Code there does not read — and take `zsh`, which is
already the login shell:

```sh
stow shell readline git ssh gh ripgrep fzf nvim code-macos ghostty tmux tmux-powerline herdr zsh
```

`stow */` fails: `bash-suse` and `bash-ubuntu` both install `~/.bashrc`. `stow -D` removes
a package, `stow -R` relinks one after a pull adds files to it.

`~/.gitconfig-local` and `~/.ssh/config.local` hold the work identities and host names that
cannot be public. Both are optional — git and ssh skip a missing include silently.

Two packages need a step beyond stowing: `tmux` and `tmux-powerline` want
[tpm](https://github.com/tmux-plugins/tpm) cloned first, and `ghostty` on macOS wants a
link to its CLI. See [`tmux/README.md`](tmux/README.md) and
[`ghostty/README.md`](ghostty/README.md).

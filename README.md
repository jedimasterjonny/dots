# dots

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose contents mirror the layout of `$HOME`.

## Packages

| Package       | Installs                                                       |
| ------------- | -------------------------------------------------------------- |
| `shell`       | `~/.config/shell/common.sh`, shared by every shell below        |
| `bash-suse`   | `~/.bashrc` for openSUSE                                        |
| `bash-ubuntu` | `~/.bashrc` for Ubuntu/Debian                                   |
| `zsh`         | `~/.zshrc`                                                      |
| `git`         | `~/.gitconfig`                                                  |
| `nvim`        | [LazyVim](https://www.lazyvim.org/) config in `~/.config/nvim`  |
| `code`        | VS Code `settings.json`                                         |
| `tmux`        | `~/.tmux.conf`                                                  |
| `tmux-powerline` | `~/.config/tmux-powerline/config.sh`                         |

`bash-suse` and `bash-ubuntu` both install `~/.bashrc`, so stow only the one matching the
machine — `stow */` fails on the conflict.

Each shell package sources `~/.config/shell/common.sh` when it exists, so stow `shell`
alongside them. That file holds the setup they share (`EDITOR`, `PATH`, brew, gcloud, nvm,
direnv) and selects the bash or zsh variant of each hook at runtime.

## Install

```sh
git clone git@github.com:jedimasterjonny/dots.git ~/dots
cd ~/dots
stow shell git nvim code tmux tmux-powerline
stow bash-suse  # or bash-ubuntu, and/or zsh
```

To remove a package:

```sh
stow -D zsh
```

## Notes

`.stowrc` sets `--no-folding`, so stow links individual files rather than whole
directories. Files a tool writes back into a stowed directory (`lazy-lock.json` and
`lazyvim.json` in `~/.config/nvim`) therefore land in a real directory outside the repo,
rather than showing up as untracked files here.

Neovim plugins are deliberately not pinned: `lazy-lock.json` stays out of the repo, so a
fresh machine installs each plugin at its latest commit. Run `:Lazy sync` to update.

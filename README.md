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

Each shell package sources two files from the `shell` package when they exist, so stow
`shell` alongside them. `common.sh` holds the environment they share — `EDITOR`, `PATH`,
brew, gcloud, nvm, npm — and `interactive.sh` holds the session setup that only means
anything at a prompt: completions, the direnv hook, aliases. Both select the bash or zsh
variant of each hook at runtime.

The split exists because the two halves want opposite positions in an rc file.
`common.sh` is sourced early, before `bash-ubuntu`'s inherited non-interactive guard, so
that `ssh host 'cmd'` gets the same `PATH` on either distro — which in turn means it must
stay silent, since `scp` and `rsync` parse that stream as their own protocol.
`interactive.sh` is sourced last, after each distro's own aliases and `PS1`, so that what
it defines outranks them. It gates itself on `$-` rather than trusting the caller, because
`bash-suse` has no non-interactive guard to hide behind.

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

### tmux plugins

`~/.tmux.conf` declares its plugins for [tpm](https://github.com/tmux-plugins/tpm) but does
not bootstrap tpm itself. The `tmux-powerline` package supplies only that plugin's config —
the plugin code comes from tpm — so a fresh machine needs tpm cloned first:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

With tmux already running, `prefix + I` fetches the plugins. Outside tmux the equivalent is
`~/.tmux/plugins/tpm/bin/install_plugins`, but it reads `TMUX_PLUGIN_MANAGER_PATH` from a
running server and aborts with `FATAL: Tmux Plugin Manager not configured in tmux.conf`
without one. So on a fresh machine source the config, install, then source again — the
plugins are not on disk to load during the first pass:

```sh
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.tmux.conf
```

## Notes

`.stowrc` sets `--no-folding`, so stow links individual files rather than whole
directories. Files a tool writes back into a stowed directory (`lazy-lock.json` and
`lazyvim.json` in `~/.config/nvim`) therefore land in a real directory outside the repo,
rather than showing up as untracked files here.

Neovim plugins are deliberately not pinned: `lazy-lock.json` stays out of the repo, so a
fresh machine installs each plugin at its latest commit. Run `:Lazy sync` to update.

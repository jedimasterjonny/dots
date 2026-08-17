# dots

Personal dotfiles for openSUSE and Ubuntu, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package mirroring `$HOME`. Stowing one symlinks its
files into place; `stow -D` removes them. No package installs the tool it configures.

## Packages

| Package          | Installs                                                       | Needs   |
| ---------------- | -------------------------------------------------------------- | ------- |
| `shell`          | `~/.config/shell/{common,interactive}.sh`                      |         |
| `bash-suse`      | `~/.bashrc` for openSUSE                                       | `shell` |
| `bash-ubuntu`    | `~/.bashrc` for Ubuntu/Debian                                  | `shell` |
| `zsh`            | `~/.zshrc`                                                     | `shell` |
| `readline`       | `~/.inputrc`                                                   |         |
| `git`            | `~/.gitconfig`, `~/.config/git/ignore`                         |         |
| `ssh`            | `~/.ssh/config`                                                |         |
| `gh`             | `~/.config/gh/config.yml`                                      |         |
| `ripgrep`        | `~/.config/ripgrep/ripgreprc`                                  | `shell` |
| `fzf`            | `~/.config/fzf/fzfrc`                                          | `shell` |
| `nvim`           | [LazyVim](https://www.lazyvim.org/) config in `~/.config/nvim` |         |
| `code`           | VS Code `settings.json`                                        |         |
| `tmux`           | `~/.tmux.conf`                                                 | tpm     |
| `tmux-powerline` | `~/.config/tmux-powerline/config.sh`                           | tpm     |

## Install

```sh
git clone git@github.com:jedimasterjonny/dots.git ~/dots
cd ~/dots
stow shell readline git ssh gh ripgrep fzf nvim code tmux tmux-powerline
stow bash-suse  # or bash-ubuntu, and/or zsh
```

`stow */` fails: `bash-suse` and `bash-ubuntu` both install `~/.bashrc`. `stow -D` removes
a package, `stow -R` relinks one after a pull adds files to it.

`~/.gitconfig-local` and `~/.ssh/config.local` hold the work identities and host names that
cannot be public. Both are optional — git and ssh skip a missing include silently.

### tmux plugins

`~/.tmux.conf` declares its plugins for [tpm](https://github.com/tmux-plugins/tpm) but does
not bootstrap tpm, and `tmux-powerline` ships only that plugin's config. So clone tpm first:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Inside tmux, `prefix + I` fetches the plugins. Outside it, `install_plugins` reads
`TMUX_PLUGIN_MANAGER_PATH` from a running server and aborts without one — and the plugins
are not on disk to load on the first pass. Hence source, install, source:

```sh
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.tmux.conf
```

## Notes

- **`shell`** — `common.sh` is environment (`EDITOR`, `PATH`, brew, gcloud, nvm, npm),
  sourced first so `ssh host 'cmd'` gets the same `PATH` on either distro, and silent for
  the same reason: `scp` and `rsync` parse that stream as their own protocol.
  `interactive.sh` is prompt-only (completions, direnv, fzf, aliases), sourced last so it
  outranks each distro's own aliases and `PS1`, and gates on `$-` itself because
  `bash-suse` has no non-interactive guard to hide behind.
- **`readline`** — Its own package because `~/.inputrc` applies to every readline program,
  not just bash. It opens with `$include /etc/inputrc` since readline reads one init file
  and does not merge, so its mere existence would drop the distro's arrow-key and
  word-motion bindings; the one addition is `enable-bracketed-paste`, which makes a
  multi-line paste arrive as a single editable command instead of executing a line at
  every newline — on by default in bash since 5.1, but openSUSE's build reports it off
  with no init file present.
- **`git`** — Nothing points at `~/.config/git/ignore`: `core.excludesFile` is unset and
  this is the path git falls back to. It holds patterns that follow the machine rather
  than the project.
- **`ssh`** — `Include ~/.ssh/config.local` has to be the first line: ssh keeps the
  *first* value it reads for a keyword, the reverse of git, so a `Host *` block above it
  would win every override. Control sockets go to `/run/user/%i/ssh-%C`, a tmpfs logind
  clears on logout, with `%C` hashing the destination to fit the ~104 byte limit on a unix
  socket path.
- **`gh`** — Only the keys that differ from gh's defaults. `hosts.yml` holds the OAuth
  token and stays untracked beside it, which is what `--no-folding` guards; gh rewrites
  the file in place through the symlink, so an alias added at the prompt shows up here as
  an ordinary edit.
- **`ripgrep`** — Inert without `shell`, since ripgrep reads no config unless
  `RIPGREP_CONFIG_PATH` names one. Set in `common.sh` so `ssh host 'rg …'` searches by the
  same rules as a prompt, and guarded on the file existing: pointing it at nothing makes
  every single `rg` call print a read error.
- **`fzf`** — Inert without `shell` too, but set up in `interactive.sh` — a remote command
  can do nothing with a full-screen picker. A bare `fzf` goes through `rg --files`, while
  `FZF_CTRL_T_COMMAND` is left unset on purpose so CTRL-T keeps fzf's own walker, which
  offers the directories and gitignored-but-wanted files that `rg --files` drops. The key
  bindings need fzf 0.48 or newer.
- **`nvim`** — Plugins are deliberately unpinned: `lazy-lock.json` stays out of the repo,
  so a fresh machine takes each at its latest commit. `:Lazy sync` to update.
- **Stow** — `.stowrc` sets `--no-folding`, so stow links individual files rather than
  whole directories. Files a tool writes back into a stowed directory (`lazy-lock.json`
  and `lazyvim.json` in `~/.config/nvim`) then land in a real directory outside the repo,
  rather than showing up as untracked files here.

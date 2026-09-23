# nvim

[LazyVim](https://www.lazyvim.org/) config.

Plugins are deliberately unpinned: `lazy-lock.json` stays out of the repo, so a fresh
machine takes each plugin at its latest commit. `:Lazy sync` to update.

That works because `.stowrc` sets `--no-folding`. Stow links individual files, so
`~/.config/nvim` is a real directory rather than a symlink into this repo, and the files
lazy.nvim writes back into it — `lazy-lock.json`, `lazyvim.json` — land outside the working
tree instead of showing up here as untracked.

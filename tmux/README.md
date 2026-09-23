# tmux

`~/.tmux.conf` declares its plugins for [tpm](https://github.com/tmux-plugins/tpm) but does
not bootstrap tpm itself, and the `tmux-powerline` package ships only that plugin's config.
Clone tpm before either is any use:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Inside tmux, `prefix + I` fetches the plugins. Outside it, `install_plugins` reads
`TMUX_PLUGIN_MANAGER_PATH` from a running server and aborts without one — and on the first
pass the plugins are not on disk to load. Hence source, install, source:

```sh
tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
tmux source-file ~/.tmux.conf
```

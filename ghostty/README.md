# ghostty

Two settings, both load-bearing; the reasoning for each is in the config file itself.

## macOS: the CLI is not on PATH

The binary lives inside the `.app`, so anything looking for a `ghostty` executable —
`snacks.nvim`'s health check among them — reports the terminal unsupported until a link
exists in a directory the `shell` package already prepends:

```sh
mkdir -p ~/.local/bin
ln -sf /Applications/Ghostty.app/Contents/MacOS/ghostty ~/.local/bin/ghostty
```

## terminfo

`shell-integration-features` turns on `ssh-terminfo`, which installs the `xterm-ghostty`
entry on hosts this machine ssh's to. It only reaches connections its own shell wrapper
wraps, so a multiplexed or proxied session, a remote command, or another client arrives
without it having run — and ncurses files the definition as `ghostty` with no
`xterm-ghostty` alias, which is the name Ghostty actually sets.

The `shell` package closes that from the receiving end, compiling the alias on first use.
Details in the terminfo block of `shell/.config/shell/common.sh`.

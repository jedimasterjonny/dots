# code-macos

VS Code reads `~/.config/Code/User/` on Linux and `~/Library/Application Support/Code/User/`
on macOS. The `code` package installs the first, this one the second.

`settings.json` here is a relative symlink back to `code`'s copy rather than a second copy,
so the two platform packages cannot drift — the file is written once and reached by two
paths. Git stores it as mode 120000, so a clone reconstructs the link rather than
materialising a duplicate. Stowing gives:

```text
~/Library/Application Support/Code/User/settings.json
  -> code-macos/Library/Application Support/Code/User/settings.json
  -> code/.config/Code/User/settings.json
```

Never stow `code` and `code-macos` together. They target different paths, so stow will
happily place both and leave two live settings files; the exclusivity is convention, not
something a conflict will catch for you.

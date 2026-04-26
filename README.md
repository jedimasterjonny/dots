# dots

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose contents mirror the layout of `$HOME`.

## Install

```sh
git clone git@github.com:jedimasterjonny/dots.git ~/dots
cd ~/dots
stow */
```

Or install a single package:

```sh
stow zsh
```

To remove:

```sh
stow -D zsh
```

## Notes

`.stowrc` enables `--no-folding` so individual files can be replaced without restowing the whole package.

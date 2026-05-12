# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Usage

Clone the repo to `~/dotfiles`, then symlink a package into `~`:

```sh
cd ~/dotfiles
stow <package>
```

## Structure

Each top-level directory is a Stow package. Files inside mirror the path they should appear at relative to `~`.

```
dotfiles/
  zsh/
    .zshrc
  git/
    .gitconfig
  ...
```

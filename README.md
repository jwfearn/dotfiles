# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Bootstrap

On a fresh machine, paste this into a terminal (works in zsh and bash):

```sh
[ -d ~/dotfiles ] || git clone https://github.com/jwfearn/dotfiles.git ~/dotfiles && ~/dotfiles/scripts/.local/bin/up-jf.sh
```

This clones the repo to `~/dotfiles` if not already present, then runs `up-jf.sh` to check the system. Once an SSH key is configured, update the remote with:

```sh
git -C ~/dotfiles remote set-url origin git@github.com:jwfearn/dotfiles.git
```

## Structure

Each top-level directory is a Stow package whose contents mirror the target directory structure relative to `~`.

```
dotfiles/
  git/        → ~/.gitconfig
  scripts/    → ~/.local/bin/
  shell/      → ~/.config/shell/, ~/.zshrc, ~/.cache/
  ssh/        → ~/.ssh/config
```

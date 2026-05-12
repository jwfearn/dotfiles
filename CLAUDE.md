# CLAUDE.md

This repo contains personal dotfiles managed with GNU Stow.

## Layout

Each top-level directory is a Stow package whose contents mirror the target directory structure (typically `~`).

## Common tasks

- **Add a new dotfile:** Place it under the appropriate package directory, then run `stow <package>` from `~/dotfiles`.
- **Remove a symlink:** Run `stow -D <package>` from `~/dotfiles`.
- **Restow (refresh symlinks):** Run `stow -R <package>` from `~/dotfiles`.

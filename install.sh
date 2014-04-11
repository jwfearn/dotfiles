#!/usr/bin/env bash
# TODO: if git not found, echo "git required, see README:" followed by README.md and exit 1
#which git
#git --version

H=~                      # home directory
D=$H/dotfiles            # dotfiles directory
T=$(date +%s)            # timestamp
B=$H/dotfiles_backup_$T  # backup directory
X=(README.md install.sh install.bat)       # excludes

pushd D

# TODO: for each non-git-ignored file or directory
for path in $D/*; do  # TODO: include $D/.* and $D/*
  f=$(basename $path)
  # TODO: if excluded, skip
  ok=1
  if $ok; then
    if test -e $f; then # TODO: if f in H
      echo "WOULD DO: mkdir -p $B"
      echo "WOULD DO: mv $H/$f $B/$f"
    fi
  fi
  echo "WOULD DO: ln -s $H/$f $D/$f" # TODO: overwrite existing file
done

popd

#!/usr/bin/env bash

H=~                                   # home directory
D=$H/dotfiles                         # dotfiles directory
T=$(date +%s)                         # timestamp
B=$H/dotfiles_backup_$T               # backup directory
X=(README.md install.sh install.bat)  # excludes

pushd $D

# TODO: for each non-git-ignored file or directory
fs=$(git ls-tree --full-tree --name-only HEAD)  # non-git-ignored files AND dirs?
#echo fs = ${fs[*]}
#echo X = ${X[*]}

#echo ${fs[@]#install.bat}
#${fs[@]/install.sh/bar}
#${fs[@]/README.md/baz}


for f in ${fs}; do  # TODO: include $D/.* and $D/*
  #  f=$(basename $path)
  # TODO: if excluded, skip
  ok=1
  if [[ ${ok} ]]; then
    if [[ -e ${f} ]]; then # TODO: if f in H
      echo "WOULD DO: mkdir -p $B"
      echo "WOULD DO: mv $H/$f $B/$f"
    fi
  fi
  echo "WOULD DO: ln -s $H/$f $D/$f" # TODO: overwrite existing file
done

popd

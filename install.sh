#!/usr/bin/env bash


H=~
DOTS=${H}/dotfiles
# Create a (local) timestamp, format: YYYYMMDDHHMMSS.
T=$(date +%Y%m%d%H%M%S)
BAK=${DOTS}_backup_${T}
EXCLUDES=".gitignore README.md install.bat install.sh"

pushd $DOTS

# Get top-level non-ignored file and directory basenames.
for f in $(git ls-tree --full-tree --name-only HEAD); do
  # If not excluded
  if [[ "${EXCLUDES##*$f*}" ]]; then
    # If found in home directory
    if [[ -e "$H/$f" ]]; then
#      echo "WOULD DO: mkdir -p $BAK"
      echo "WOULD DO: mv $H/$f $BAK/$f"
#     TODO: If not a link, back it up
    fi
#    echo $f
#  else
#    echo EXCLUDED: $f
  fi
#  echo "WOULD DO: ln -s $H/$f $DOTS/$f" # TODO: overwrite existing file
done

popd





# TODO: for each non-git-ignored file or directory
#echo fs = ${fs[*]}
#echo X = ${X[*]}

#echo ${fs[@]#install.bat}
#${fs[@]/install.sh/bar}
#${fs[@]/README.md/baz}



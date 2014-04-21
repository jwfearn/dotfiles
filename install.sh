#!/usr/bin/env bash
set -o nounset
set -o errexit


function main() {

  local H=~
  local DOTS=${H}/dotfiles
  # Create a (local) timestamp, format: YYYYMMDDHHMMSS.
#  local T=$(date +%Y%m%d%H%M%S)
  timestamp T
  local BAK=${DOTS}_backup_${T}
  local EXCLUDES=".gitignore README.md install.bat install.sh"

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
}

function timestamp {
  local t=$(date +%Y%m%d%H%M%S)
  ${$1}=t
}

function symlink {
  local name=xxx
  local target=xxx
  $(ln -s name target)
}

function backup {
  # Copy f (relative to working directory) to d (absolute path), creating d
  # if it doesn't exist.  Do nothing if f is a link.
  local basename=xxx
  local d=xxx
  local ok=0
  if [[ ok ]]; then
    mkdir -p d
    echo "WOULD DO: mv $H/$f $d/$f"
  fi
}

function islink {
  local f=xxx
}


main


# TODO: for each non-git-ignored file or directory
#echo fs = ${fs[*]}
#echo X = ${X[*]}

#echo ${fs[@]#install.bat}
#${fs[@]/install.sh/bar}
#${fs[@]/README.md/baz}



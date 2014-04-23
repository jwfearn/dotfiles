#!/usr/bin/env bash
set -o nounset
set -o errexit

function main() {

  local H=~
  local DOTS=${H}/dotfiles
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
  # @param-out $1 Receives a (local) timestamp, format: YYYYMMDDHHMMSS.
  local t=$(date +%Y%m%d%H%M%S)
  if [[ $1 ]]; then
    eval "$1=\$t"
  fi
}

function symlink {
  # Create a symbolic link.
  # @param-in $1 Name (relative) of link being created.
  # @param-in $2 Path (relative or absolute) to which new link refers.
  local shortcut=$1
  local original=$2
  $(ln -s shortcut original)
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



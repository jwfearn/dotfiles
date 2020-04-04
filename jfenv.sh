#! /usr/bin/env sh
# shellcheck disable=SC1090

# jfenv.sh - may be exectued by bash OR zsh

# NOTE: environment variables used by both shell and non-shell programs
# are set in /etc/launchd.conf (and ~/.launchd.conf?)

# environment variables used by multiple shells
export SHELLCHECK_OPTS='--exclude=SC1090,SC2164'

# load secrets
O=$(set +o) && set -o allexport && . "${HOME}/.env.secret.sh"; eval "${O}"

export PGUSER=postgres # used by `psql`
export PGPORT=5432 # conmpare to setting in /usr/local/var/postgres/postgresql.conf

export ERL_AFLAGS='-kernel shell_history enabled'

export EDITOR='subl -w'
export WWW_HOME='google.com'

export AWS_ACCESS_KEY_ID="${JOHN_AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${JOHN_AWS_SECRET_ACCESS_KEY}"

## Roku
export MAC_4640X_HOME='88:de:a9:c0:4e:fc'
export IP_3800X_HOME='192.168.1.140'
export IP_4200X_HOME='192.168.1.205'
export IP_4640X_HOME='192.168.1.163' # Ethernet: 88:de:a9:c0:4e:fc, WiFi: 88:de:a9:c0:4e:fd
export IP_8101X_HOME='192.168.1.33'
export IP_3900X_WORK='10.30.63.6' # WiFi: d8:31:34:c6:db:6e
export IP_4230X_WORK='10.30.0.110' # Ethernet b8:a1:75:6b:3b:d2
export ROKU_DEV_TARGET="${IP_4230X_WORK}"
# export ROKU_DEV_TARGET='192.168.1.114'
export DEVPASSWORD="${ROKU_DEV_PASSWORD_WORK}"
export ROKU_DEV_USER="rokudev:${DEVPASSWORD}"

add_libpath() {
  local libpath="$1"

  # headers
  export C_INCLUDE_PATH="${C_INCLUDE_PATH}:${libpath}/include"
  export CPLUS_INCLUDE_PATH="${CPLUS_INCLUDE_PATH}:${libpath}/include"
  export OBJC_INCLUDE_PATH="${OBJC_INCLUDE_PATH}:${libpath}/include"
  export OBJCPLUS_INCLUDE_PATH="${OBJCPLUS_INCLUDE_PATH}:${libpath}/include"
  # linkables
  export LDFLAGS="${LDFLAGS} -L${libpath}/lib"
  # packages
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${libpath}/lib/pkgconfig"
  # executables
  export PATH="${PATH}:${libpath}/bin"
}

libs=( \
  'icu4c' \
  'jpeg-turbo' \
  'libffi' \
  'libidn2' \
  'libjpg' \
  'libpng' \
  'libtiff' \
  'libunistring' \
  'mozjpeg' \
  'ncurses' \
  'openssl@1.1' \
  'readline' \
  'sqlite' \
  'zlib' \
)
for lib in ${libs[@]}; do
  # libpath=$(brew --prefix ${lib}) # safer
  libpath="/usr/local/opt/${lib}" # faster
  add_libpath "${libpath}"
done

export STDOUT_SYNC=1

[ -z "${MSYSTEM}" ] && export GREP_OPTIONS='--color=auto'

# export LS_COLORS='' # Linux
# export LSCOLORS='' # OS X,
export CLICOLOR=1 # use colors in supported commands (ls, others?)

export PATH="${PATH}:${HOME}/.mix/escripts"
# export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:/usr/local/opt/go/libexec/bin"
export PATH="${PATH}:/usr/local/opt/sca-cmd/bin"
export PATH="${PATH}:${HOME}/Library/Android/sdk/platform-tools"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:/usr/local/Cellar/zookeeper/3.4.9/bin"
export PATH="${PATH}:${HOME}/nand2tetris/tools"

export MANPATH="${MANPATH}:/usr/local/opt/erlang/lib/erlang/man"
export MANPATH="${MANPATH}:/usr/local/opt/coreutils/libexec/gnuman"

#! /usr/bin/env sh
# shellcheck disable=SC1090

# jfenv.sh - may be exectued by bash OR zsh

# NOTE: environment variables used by both shell and non-shell programs
# are set in /etc/launchd.conf (and ~/.launchd.conf?)

# environment variables used by multiple shells
export SHELLCHECK_OPTS='--exclude=SC1090,SC2164'

export ERL_AFLAGS='-kernel shell_history enabled'

export EDITOR='subl -w'
export WWW_HOME='google.com'

libs=( \
  'libpng' \
  'libtiff' \
  'openssl' \
  'readline' \
)
for lib in ${libs[@]}; do
  # libpath=$(brew --prefix ${lib}) # safer
  libpath="/usr/local/opt/${lib}" # faster
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
done

export STDOUT_SYNC=1

[ -z "${MSYSTEM}" ] && export GREP_OPTIONS='--color=auto'

# export LS_COLORS='' # Linux
# export LSCOLORS='' # OS X,
export CLICOLOR=1 # use colors in supported commands (ls, others?)

# load secrets
O=$(set +o) && set -o allexport && . "${HOME}/.env.secret.sh"; eval "${O}"

## environment variables for ec2-api-tools
#export AWS_ACCESS_KEY="${AMAZON_ACCESS_KEY_ID}" # still needed?
#export AWS_SECRET_KEY="${AMAZON_SECRET_ACCESS_KEY}" # still needed?
## environment variables for Homebrew
# export AWS_ACCESS_KEY_ID="${AMAZON_ACCESS_KEY_ID}"
# export AWS_SECRET_ACCESS_KEY="${AMAZON_SECRET_ACCESS_KEY}"
# export AWS_REGION="${AMAZON_REGION}"

# required by brew-installed ec2-api-tools
# export JAVA_HOME="$(/usr/libexec/java_home)"
# export JAVA_HOME="$(jenv javahome)"
# export EC2_HOME="$(dirname $(dirname $(grealpath $(which ec2ver))))/libexec"

# export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt"

# export QMAKE='/usr/local/opt/qt5/bin/qmake' # default brew install qt5 location
# export CHEF_CLIENT_NAME='john'

export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:/usr/local/opt/go/libexec/bin"
export PATH="${PATH}:${HOME}/Library/Android/sdk/platform-tools"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:/usr/local/Cellar/zookeeper/3.4.9/bin"
export PATH="${PATH}:${HOME}/nand2tetris/tools"

export MANPATH="${MANPATH}:/usr/local/opt/erlang/lib/erlang/man"
export MANPATH="${MANPATH}:/usr/local/opt/coreutils/libexec/gnuman"

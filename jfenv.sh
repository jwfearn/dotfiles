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
  'gettext' \
  'icu4c' \
  'imagemagick@6' \
  'libxml2' \
  'mysql@5.6' \
  'openssl' \
  'qt' \
  'readline' \
  'zlib' \
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

export TWILIO_ACCOUNT_SID="${TEST_TWILIO_ACCOUNT_SID}"
export TWILIO_AUTH_TOKEN="${TEST_TWILIO_AUTH_TOKEN}"

# base_url port numbers should agree with Procfile else will default to stag

export ACCOUNT_BASE_URL_LOCAL='http://localhost:5029/'
export ACCOUNT_BASE_URL_STAG='http://sv1stag.corp.avvo.com:4028/'
export ACCOUNT_BASE_URL="${ACCOUNT_BASE_URL_STAG}"

export AMOS_BASE_URL_LOCAL='http://localhost:3000/' # is this a thing?
export AMOS_BASE_URL_STAG='https://stag.avvo.com/'
export AMOS_BASE_URL="${AMOS_BASE_URL_STAG}"

export BILLBOARD_BASE_URL_LOCAL='http://localhost:5024/' # was 5008
export BILLBOARD_BASE_URL_STAG='xxx'
export BILLBOARD_BASE_URL="${BILLBOARD_BASE_URL_LOCAL}"

export CONTENT_BASE_URL_LOCAL='http://localhost:5004/'
export CONTENT_BASE_URL_STAG='xxx'
export CONTENT_BASE_URL="${CONTENT_BASE_URL_LOCAL}"

export GNOMON_BASE_URL_LOCAL='http://localhost:5005/'
export GNOMON_BASE_URL_STAG='http://gnomonstag.corp.avvo.com/'
export GNOMON_BASE_URL="${GNOMON_BASE_URL_STAG}"

export INCEPTION_BASE_URL_LOCAL='http://localhost:5090/'
export INCEPTION_BASE_URL_STAG='https://api.stag.avvo.com/'
export INCEPTION_BASE_URL="${INCEPTION_BASE_URL_STAG}"

export LEDGER_BASE_URL_LOCAL='http://localhost:5002/'
export LEDGER_BASE_URL_STAG='xxx'
export LEDGER_BASE_URL="${LEDGER_BASE_URL_LOCAL}"

export QUASI_BASE_URL_LOCAL='http://localhost:5001/'
export QUASI_BASE_URL_STAG='xxx'
export QUASI_BASE_URL="${QUASI_BASE_URL_LOCAL}"

export SOLICITOR_BASE_URL_LOCAL='http://localhost:5007/'
export SOLICITOR_BASE_URL_STAG='http://solicitorstag.corp.avvo.com/' # stag
export SOLICITOR_BASE_URL="${SOLICITOR_BASE_URL_STAG}"

export KAFKA_HOSTS='127.0.0.1:9092'
export ZOOKEEPER_HOSTS='127.0.0.1:2181'
# export ZOOKEEPER_HOSTS='nn1test.prod.avvo.com:2181,nn2test.prod.avvo.com:2181,dn3test.prod.avvo.com:2181' # stag

# export STRANGER_FORCES_TRACE=0

[ -z "${MSYSTEM}" ] && export GREP_OPTIONS='--color=auto'

# pip should only run if there is a virtualenv currently activated
# export PIP_REQUIRE_VIRTUALENV=true

## Spark-related variables
# export PYSPARK_PYTHON="${HOME}/.pyenv/shims/python"
# export SPARK_HOME="$(dirname $(dirname $(grealpath $(which pyspark))))/libexec"
# export IPYTHON=1  # use ipython shell for spark interactive shell
# export SPARK_PEM="${HOME}/.ssh/apptentive.pem"
# export APPTENTIVE_CLUSTER_TEST=1

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

#TODO: should ATLAS_TOKEN be secret?
# export ATLAS_TOKEN=xDqPJadMbAnySVCqwdLaRKVrokxSq26M8pXqg_By_hMHqv8-KEFKjGs4YLyHyssLYcY
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:/usr/local/opt/go/libexec/bin"
export PATH="${PATH}:${HOME}/Library/Android/sdk/platform-tools"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:/usr/local/Cellar/zookeeper/3.4.9/bin"
export PATH="${PATH}:${HOME}/nand2tetris/tools"
# export PATH=JFENV-:/usr/local/Cellar/gnu-getopt/1.1.5/bin:$PATH:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV
# export PATH="JFENV-:${PATH}:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV"
#:${SPARK_HOME}/ec2"

export MANPATH="${MANPATH}:/usr/local/opt/erlang/lib/erlang/man"
export MANPATH="${MANPATH}:/usr/local/opt/coreutils/libexec/gnuman"

# jfenv.sh - may be exectued by bash OR zsh

# NOTE: environment variables used by both shell and non-shell programs
# are set in /etc/launchd.conf (and ~/.launchd.conf?)

# environment variables used by multiple shells

export EDITOR='subl -w'

[[ -z ${MSYSTEM} ]] && export GREP_OPTIONS='--color=auto'

# pip should only run if there is a virtualenv currently activated
# export PIP_REQUIRE_VIRTUALENV=true

## Spark-related variables
export PYSPARK_PYTHON="${HOME}/.pyenv/shims/python"
export SPARK_HOME="$(dirname $(dirname $(grealpath $(which pyspark))))/libexec"
export IPYTHON=1  # use ipython shell for spark interactive shell
export SPARK_PEM="${HOME}/.ssh/apptentive.pem"
export APPTENTIVE_CLUSTER_TEST=1

# export LS_COLORS='' # Linux
# export LSCOLORS='' # OS X,
export CLICOLOR=1 # use colors in supported commands (ls, others?)

# load secrets
O=$(set +o) && set -o allexport && . "${HOME}/.env"; eval "${O}"

## environment variables for ec2-api-tools
#export AWS_ACCESS_KEY="${AMAZON_ACCESS_KEY_ID}" # still needed?
#export AWS_SECRET_KEY="${AMAZON_SECRET_ACCESS_KEY}" # still needed?
## environment variables for Homebrew
# export AWS_ACCESS_KEY_ID="${AMAZON_ACCESS_KEY_ID}"
# export AWS_SECRET_ACCESS_KEY="${AMAZON_SECRET_ACCESS_KEY}"
# export AWS_REGION="${AMAZON_REGION}"

# required by brew-installed ec2-api-tools
# export JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME="$(jenv javahome)"
export EC2_HOME="$(dirname $(dirname $(grealpath $(which ec2ver))))/libexec"

# export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt"

export QMAKE='/usr/local/opt/qt5/bin/qmake' # default brew install qt5 location
export CHEF_CLIENT_NAME='john'

#TODO: should ATLAS_TOKEN be secret?
export ATLAS_TOKEN=xDqPJadMbAnySVCqwdLaRKVrokxSq26M8pXqg_By_hMHqv8-KEFKjGs4YLyHyssLYcY

# export PATH=JFENV-:/usr/local/Cellar/gnu-getopt/1.1.5/bin:$PATH:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV
# export PATH="JFENV-:${PATH}:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV"
export PATH="/usr/local/sbin:${PATH}:${HOME}/bin:${SPARK_HOME}/ec2"

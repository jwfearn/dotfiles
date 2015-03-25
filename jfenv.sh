# jfenv.sh - may be exectued by bash OR zsh

# NOTE: environment variables used by both shell and non-shell programs
# are set in /etc/launchd.conf (and ~/.launchd.conf?)

# environment variables used by multiple shells

# export LINKSCAPE_REPO_ROOT=${HOME}/github/linkscape
# export PATH=JFENV-:/usr/local/Cellar/gnu-getopt/1.1.5/bin:$PATH:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV
export PATH="JFENV-:${PATH}:${HOME}/bin:/usr/local/mysql/bin:/usr/local/packer:-JFENV"
export EDITOR='subl -w'
export CLICOLOR=YES
#export MOZOO_PATH=~/github/mozoo (moved to launchd.conf to support RM)
#export GREP_OPTIONS='--color=auto'

# pip should only run if there is a virtualenv currently activated
# export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE="${HOME}/.pip/cache"

# export LS_COLORS='' # Linux
# export LSCOLORS='' # OS X,
export CLICOLOR=1 # use colors in supported commands (ls, others?)

## Secrets!
export EC2_CERT="${HOME}/.ssh/bigdata20140401/bigdata20140401.cert"  # deprecated?
export EC2_PRIVATE_KEY="${HOME}/.ssh/bigdata20140401/bigdata-20140401.pk"  # deprecated?
export MOZSCAPE_KEY="${HOME}/.ssh/bigdata20140401/bigdata-20140401.pem"

. "${HOME}/github/linkscape/scripts/secrets.sh"
# environment variables for ec2-api-tools
export AWS_ACCESS_KEY="${AMAZON_ACCESS_KEY_ID}"
export AWS_SECRET_KEY="${AMAZON_SECRET_ACCESS_KEY}"


# required by brew-installed ec2-api-tools
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.7.3.0/libexec"

# export FLAGS_GETOPT_CMD="/usr/local/opt/gnu-getopt"

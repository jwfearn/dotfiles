#! /usr/bin/env sh

# shellcheck disable=SC2039

## aliases
alias 'cd..'='cd ..' # 'cd..' cannot be a function name
alias 'cd...'='cd ../..'
alias 'cd....'='cd ../../..'
alias 'cd.....'='cd ../../../..'
alias 'cd-'='cd -'
alias 'wat'="git for-each-ref --count=30 --sort=committerdate refs/head/ --format='%(refname:short)' | fzf | xargs git checkout"
alias 'ls'='ls -haF'
alias 'll'='ls -l'
# l() { ls "$@"; }

# Version 0.9.4 is available! (You are running version 0.9.3) Please download our latest version.
op_() { which op > /dev/null && op "$@"; }
opu() {
  local msg=$(op_ update "$@")
  echo "${msg}"
  # if msg contains "available" and msg does not contain "http", then echo link to op downloads page
  echo "Check here: http://xxx.xxx"
}

keyrates() {
  defaults read NSGlobalDomain KeyRepeat
  defaults read NSGlobalDomain InitialKeyRepeat
}

keyrates_set() {
  defaults write NSGlobalDomain KeyRepeat -int ${1:-6}
  defaults write NSGlobalDomain InitialKeyRepeat -int  ${2:-25}
  echo "KeyRepeat changes will take effect after restart"
  keyrates
}

keyrates_jf() { keyrates_set 2; }

## Homebrew-related functions
o() {
  echo "OUTDATED PYTHON PACKAGES?" \
  && ppo \
  && echo "OUTDATED RUBY GEMS?" \
  && rgo \
  && echo "OUTDATED NODE PACKAGES?" \
  && npo \
  && echo "OUTDATED 1PASSWORD?" \
  && opu \
  && echo "OUTDATED HOMEBREW PACKAGES AND DIAGNOSIS?" \
  && bod;
}
bod() { brew update && brew outdated && brew doctor; }
buc() { brew upgrade; brew cleanup; }
bs() { brew services "$@"; }
bss() { brew services list "$@"; }

## 1Password-related functions
opsi() { eval $(op signin my) "$@"; }
opso() { op signout "$@"; }

# alias irb='irb --'
hs() { HardwareSimulator.sh "$1.tst"; }
ce() { Assembler.sh "$1.asm" && CPUEmulator.sh "$1.tst"; }
#ktopics() { ; }

## formatters
exf() { mix format "$@"; }
mdf() {
  local f="${1:-README.md}"
  prettier --prose-wrap=always --print-width=80 "${f}" | sponge "${f}"
}

pping() { prettyping "$@"; }
myip() { ipconfig getifaddr "${1:-en0}" "$@"; }
myifs() { ifconfig -l "$@"; }
myips() {
  for interface in $(ifconfig -l); do
    local ip=$(ipconfig getifaddr $interface)
    [ -n "${ip}" ] && printf "%8s %s\n" "${interface}" "${ip}"
  done
}
# mac2ip() { arp -an | grep "$1" | tr '(' ' ' | tr ')' ' ' | gawk -v MAC="$1" '{print $2}'; }
# mac2ip() { arp -a | awk '$4 ~ /'$1'/ { print substr($2, 2, length($2) - 2) }'; }
# mac2ip() { arp -a | awk -F '[ ()]+' '$4 ~ /'$1'/ { print $2 }'; }
mac2ip() { arp -a | awk -F '[ ()]+' -v IGNORECASE=1 '$4 ~ /'$1'/ { print $2 }'; }
mycores() { sysctl -n hw.physicalcpu; }

q() { mysql -p -uroot "$@"; }

anyrspec1() { find "${1:-.}" -type f -name '*_spec.rb' | head -1; } # fast
anyrspec2() { find "${1:-.}" -type f -name '*_spec.rb' \( -exec echo {} \; -quit \) 2> /dev/null; } # faster
anyrspec3() { find "${1:-.}" -name '*_spec.rb' -print -quit; } # faster, simpler
anyrspec4() { compgen -G 'spec/**/*_spec.rb'; } # fastest but not ZShell-compatible

t() {
  if [ -f 'yarn.lock' ]; then # Yarn
    time yarn test  "$@"
  elif [ -f 'mix.exs' ]; then # ExUnit
    time MIX_ENV='test' mix test "$@"
  else
    if [ -n "$(find 'spec' -name '*_spec.rb' -print -quit 2> /dev/null)" ]; then # Rspec
      local cmd="rspec --color $@"
    elif [ -d 'test' ]; then # Minitest
      if [ -z "$@" ]; then # no args
        local cmd='rake test'
      else
        local cmd="ruby -Ilib:test $@"
      fi
    fi
    [ -z "${cmd}" ] && printf "no tests found\n" && return 1
    time LOGGER_LEVEL='debug' RAILS_ENV='test' bundle exec "${cmd}"
  fi
}

tmc() { MIX_ENV=test mix coveralls.html && open 'cover/excoveralls.html'; }

yt() {
  pushd "${HOME}/repos/avvo/scooter/apps/scooter_web/assets"
  yarn test "$@"
  popd
}

whilepass() { while $1; do :; done; }
whilefail() { while ! $1 ; do :; done; }

vt() { TESTOPTS='--verbose' t "$@"; }

man() {
  env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    env man "$@"
}


pathpp() {
  saveIFS="${IFS}"
  IFS=":"
  for segment in ${PATH}; do
    if [ -d "${segment}" ]; then
      segment="$(cd "${segment}" && pwd)"
      echo "${segment}"
    fi
  done
  IFS=${saveIFS}
}

pathhas() {  # return 0 if path contains d
  local ret=1
  local readonly d="$1"  #TODO ensure d is expanded to absolute path
  saveIFS="${IFS}"
  IFS=":"
  for segment in ${PATH}; do
    if [ "${segment}" ]; then  #TODO ensure segment is expanded to absolute path
      ret=0
      break
    fi
  done
  IFS="${saveIFS}"
  return "${ret}"
}

# pathadd() { # add to path only if not already there
#   local readonly d=$1
# }

pathadd() {
  local readonly d
  d="$(cd "$1" && pwd)"
  if [ -d "${d}" ] && [ ":${PATH}:" != *":${d}:"* ]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}


# pathrm() { # remove all path segments matching pattern (filename matching rules)
#   $pattern=$1
# }

# SSH-related functions
sshi() { tree /private/etc/ssh; tree "${HOME}/.ssh/"; ssh -V;}
tunnelthor() { ssh -L 7706:localhost:3306 -p 2022 root@zabbix.seomoz.org; } # local port forwarding
cmux() { lmux.sh crawl 20; }
pmux() { lmux.sh processing xxx; }
smux() { lmux.sh url 10; }


# POSTGRESQL RE-INSTALL
# =====================
#.  brew uninstall postgresql
#.  rm -rf /usr/local/var/postgres                  # DANGER! REMOVES ALL DATABASES
#.  brew install postgresql
#   brew services stop postgresql
#.  subl /usr/local/var/postgres/postgresql.conf    # CHANGE PORT TO 5433
#.  rm -rf /usr/local/var/postgres                  # DANGER! REMOVES ALL DATABASES
#.  initdb --username=postgres --local=en_US --encoding=UTF8 /usr/local/var/postgres
#   brew services start postgresql

pgs() { psql -l "$@"; } # list dbs, requires running postgresql service
pgrc() { subl /usr/local/var/postgres/postgresql.conf; };
pgstop() { brew services stop postgresql "$@"; }
pgstart() { brew services start postgresql "$@"; }
pgrestart() { brew services restart postgresql "$@"; }

## tmux-related functions
tls() { tmux list-sessions "$@"; }
tlw() { tmux list-windows "$@"; }
tks() { tmux kill-session "$@"; }
tas() { tmux attach-session -t "$@"; }
taw() { taw "$@"; }


## screen-related functions
sls() { screen -ls "$@"; }


## DOS-like functions
cdup() { cd ..; }
cdroot() { cd / || return 1; }
cls() { clear; }
dir() { ls "$@"; }
dirb() { find "$(pwd)" -depth 1 "$@"; } # bare directory listing (like DOS: `dir /b`)

## general purpose shell functions
disks() { diskutil list; }
ts() { date '+%s'; }
vars() { env | sort -V; }
ei() { env | sort | grep "$@"; }
e() { subl "$@"; }
h() { history | tail -"$1"; }
history_remove_all() { rm "${HISTFILE}"; }
history_remove_session() { local HISTSIZE=0; }
lsl() { env ls -lOeF "$@"; }  # -O is a Mac-specific option
lsd() { env ls -d .*/ "$@"; }
lsapts() {
  local F='/etc/apt/sources.list'
  local D="${L}.d"
  [ -f ${F} ] && lsb ${F}; [ -d "${D}" ] && lsb "${D}"
}
pushd_() { pushd "$@" > /dev/null; }
popd_() { popd "$@" > /dev/null; }
posh() { powershell "$@"; }

lk() { open -a ScreenSaverEngine; }

_path() { echo $1 | tr ':' '\n'; }
cpath() { _path "${C_INCLUDE_PATH}"; }
cppath() { _path "${CPLUS_INCLUDE_PATH}"; }
path() { _path "${PATH}"; }
ppath() { _path "${PKG_CONFIG_PATH}"; }

func() { typeset -F; }
err() { echo $?; }
rmat() { xattr -cr; } # remove the @ attribute in macOS
_tree() { tree -I '.git|.history|.idea|_build|assets|deps|node_modules|vendor' --dirsfirst --prune -CFa "$@"; }
treef() { _tree  "$@"; }
treef1() { treef -L 1 "$@"; }
treef2() { treef -L 2 "$@"; }
treef3() { treef -L 3 "$@"; }
treef4() { treef -L 4 "$@"; }
treed() { _tree -d "$@"; }
treed1() { treed -L 1 "$@"; }
treed2() { treed -L 2 "$@"; }
treed3() { treed -L 3 "$@"; }
treed4() { treed -L 4 "$@"; }
treeg() { _tree -fi | grep "$@"; }
wh() { grealpath "$(which "$@")"; } # requires 'brew install coreutils'
broken() { find -L . -type l -ls; }
jj() { "$@" | python -mjson.tool; }
jjs() { while read l; do jj $l; done < "$@"; }
ipy() { ipython "$@"; }
psg() { ps -ef | head -1 && ps -ef | grep -v grep | grep "$@"; }
# cdiff() { diff -U0 "$@" | sed "s/^-/`echo -e \"\x1b\"`[41m-/;s/^+/`echo -e \"\x1b\"`[42m+/;s/^@/`echo -e \"\x1b\"`[34m@/;s/$/`echo -e \"\x1b\"`[0m/"; }  # Mac-only
gdiff() { git diff -U0 --no-index "$@"; }
mktags() { mkdir -p ./.tags; ctags -R -f ./.tags/tags "$@" .; }
makels() { make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort | uniq; }
csha() { curl -fSL "$@" | shasum -a 256 --; }

## OS X-specific commands
cpus() { sysctl -n hw.ncpu; }
cores() { system_profiler SPHardwareDataType | grep 'Total Number of Cores' | cut -d: -f2 | tr -d ' '; }

## cron-related functions
croni() { ls -ldF /etc/cron* /var/spool/cron/crontabs/* 2> /dev/null; }

## Mysql-related functions
mycnfs() {
  local cnfs=($(mysqld --verbose --help 2> /dev/null | grep '/my.cnf'))
  for cnf in ${cnfs[@]}; do
    ls -la "${cnf/#\~/$HOME}"
  done
}

## Docker-related functions
vk() { docker-compose run shell invoke "$@"; }
vx() { docker-compose run shell "$@"; }
vb() { docker-compose build "$@"; }
vrb() { docker-compose build --no-cache "$@"; }

# Roku xxx (as JSON)
rdbg() { bs_const='IS_AUTOMATION_BUILD=false;IS_MITMPROXY_BUILD=false;TRACE_URL_TRANSFERS=false;ENABLE_DBG=true;ENABLE_LOG=false' roku "$@"; }

rowake() { curl -d '' "http://$ROKU_DEV_TARGET:8060/keypress/Home"; }
rog() { curl -s "http://${ROKU_DEV_TARGET}:8060/$1" | xml2json | jq "${@:2}"; }
rop() { curl -d '' "http://${ROKU_DEV_TARGET}:8060/$1"; }
rob() { roku "${ROKU_DEV_TARGET}" -t "$@"; } # roku-cli build and run
roc() { telnet "${ROKU_DEV_TARGET}" 8085 "$@"; } # Roku debug console, see: https://sdkdocs.roku.com/display/sdkdoc/Debugging+Your+Application
rod() { telnet "${ROKU_DEV_TARGET}" 8080 "$@"; } # Roku debug server, see: https://sdkdocs.roku.com/display/sdkdoc/Debugging+Your+Application
ros() { open "http://${ROKU_DEV_TARGET}:8087" "$@"; } # Roku screensaver, see: https://sdkdocs.roku.com/display/sdkdoc/xxx
row() { open "http://${ROKU_DEV_TARGET}:80" "$@"; } # Roku web interface
rol() { curl -d '' "http://${ROKU_DEV_TARGET}:8060/launch/dev?startup_show_id=54"; }
ron() { # Generate Roku new user data
  local t="$(date +%s)"
  open "https://my.roku.com/signup"
  echo "   first name: jf"
  echo "    last name: ${t}"
  echo "        email: jf.${t}@roku.com"
  echo "     password: testtest"
  echo ""
  echo "  card number: 370021129040059"
  echo "        month: 06"
  echo "         year: 2023"
  echo "security code: 9546"
  echo "      address: 150 Winchester Circle"
  echo "         city: Los Gatos"
  echo "        state: CA"
  echo "          zip: 95032"
  echo "        phone: 8162728106"
  echo ""
  echo "  device name: BLASTOISE"
  echo "     location: Office"
}

mp4v() { ~/repos/other/mp4viewer/src/showboxes.py "$@"; }

## Elixir-related functions
ism() { iex -S mix "$@"; }
iexv() { iex --logger-sasl-reports true "$@"; }
myiex() { RESISTANCE_MAIN=10.3.17.89 iex --name "john@$(myip)" --cookie la_resistance -S mix; }
mrm() { rm -rf deps/ _build/ tarballs/ "$@"; } # like brm for mix
mix_each() {
  local project_dir=$(pwd)
  local app_dirs=($(env ls -d1 $PWD/apps/*/))
  for app_dir in ${app_dirs[@]}; do
    cd "${app_dir}" && pwd && mix "$@" && echo ''
  done
  cd "${project_dir}"
  pwd && mix "$@"
}
mdg() { mix deps.get "$@"; }
mdu() { mix deps.update "$@"; }
mho() { mix_each hex.outdated "$@"; }
mps() { mix phx.server "$@"; }
ips() { iex -S mix phx.server "$@"; }

killport() { kill -9 $(lsof -t -i:"$@"); }

yfd() { yarn foreman:dev "$@"; }
yfp() { yarn foreman:prod "$@"; }

## Node-relate functions
npm_() { which npm > /dev/null && npm "$@"; }
nr() { npm_ run "$@"; }
nt() { npm_ test "$@"; }
nps() { npm_ -g list --depth=0  "$@"; } # node packages
npo() { npm_ -g outdated "$@"; return 0; } # outdated node packages
npu() { npm_ -g update "$@"; } # update node packages

## Docker-related functions
rr() { docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:preview; }
rr1() { docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable; }
dsh() { docker exec -it "$@" /bin/sh; }
dlogs() { docker logs "$@"; }
dco() { docker-compose "$@"; }
dcup() { docker-compose up "$@"; }
dm() { docker-machine "$@"; }
di() {
  which docker && docker -v
  which docker-machine && docker-machine -v
  which docker-compose && docker-compose -v
}
# dmds() {
#   local readonly prefix='Available drivers: '
#   dm help create | grep "${prefix}" | sed -ne "s/^.*${prefix}//p" | sed 's/,//g'
# }
dps() { docker ps -a "$@"; }
dis() { docker images "$@"; }
dms() { dm ls; }
dmsh() { dm ssh "$@"; }
dmi() { dm inspect "$@" | jq .; }
dmu() { eval "$(dm env "$@")"; }
dmc() { dm create -d vmwarefusion --vmwarefusion-boot2docker-url 'https://github.com/cloudnativeapps/boot2docker/releases/download/v1.6.0-vmw/boot2docker-1.6.0-vmw.iso' "$1"; }
#dmc() { dm create -d vmwarefusion $1; }

## Avro-related functions
avt() { avro-tools "$@"; }

## Vagrant-related functions
vagrant_() { which vagrant > /dev/null && vagrant "$@"; }
vps() { vagrant_ plugin list "$@"; }
vinfo() { vagrant_ version; vps; vagrant_ global-status; vagrant_ status "$@" 2> /dev/null; }
vbo() { vagrant_ box outdated "$@"; }
vbs() { vagrant_ box list -i "$@"; }
vbu() { vagrant_ box update "$@"; }
vpu() { vagrant_ plugin list && vagrant_ plugin update "$@"; vagrant_ version; return 0; }

# vsh() { vagrant ssh "$@"; }
# vu() { v up --provider=vmware_fusion && vsh "$@"; }
vu() { vagrant_ up "$@"; }
vhelp() { vagrant_ help "$@"; }
vsus() { vagrant_ suspend "$@"; }
vsw() { vsus "$1" && vush "$2"; }
vd() { vagrant_ destroy -f "$@"; }
vl() { vagrant_ reload "$@"; }
vdu() { vd "$@" && vu "$@"; }
vush() { vu "$@" && vsh "$@"; }
vdush() { vd "$@" && vush "$@"; }
vrps() { vagrant_ reload --provision "$@" && vsh "$@"; }  # faster than vdus?
cdvp() { cd "${HOME}/vagrant/processing"; vp; }
cdvd() { cd "${HOME}/vagrant/boot2docker"; vp; }
cdvw() { cd "${HOME}/vagrant/vmwtest/"; }
cdvb() { cd "${HOME}/vagrant/vbtest/"; }

## Git-related functions
gi() { git --version; git status "$@"; }
gdiff_() { local b0="$1"; local b1="$2"; shift 2; git diff --color --minimal "${b0}..${b1}" "$@"; }
gstat_() { local b0="$1"; local b1="$2"; shift 2; git diff --color --minimal --stat "${b0}..${b1}" "$@"; }
gitc() {
    command git "$@"
    local exitCode=$?
    if [ $exitCode -ne 0 ]; then
        printf "\033[0;31mERROR: git exited with code $exitCode\033[0m\n"
        return $exitCode
    fi
}
# colorerr() (set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1


# gdiffl_() { pushd_ "${HOME}/repos/linkscape"; gdiff_ ${B0:-'crawl-sched-Jul-5-2013'} ${B1:-'sprint-Gordon'} "$@"; popd_; }
# gstatl_() { pushd_ "${HOME}/repos/linkscape"; gstat_ ${B0:-'crawl-sched-Jul-5-2013'} ${B1:-'sprint-Gordon'} "$@"; popd_; }

# diffb() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'liblinkscape/batch.cc'; }
# statb() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'liblinkscape/batch.cc'; }
# diffc() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'processing/crawlv2loop.cc'; }
# statc() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'processing/crawlv2loop.cc'; }
# difft() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'processing/test/batch_unittest.cc'; }
# statt() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'processing/test/batch_unittest.cc'; }

# statx() { gstatl_ "cluster"; gstatl_ "processing/cluster"; }
# statl() { gstatl_ .; }
# grab file from a particular commit.  Usage: ggrab filepath commit
ggrab() { git co "$2" -- "$1"; }
# gmm() { git merge master; }
# grm() { git rebase master; }
grl() { git reflog --format=format:"%C(yellow)%h %Cblue%aD%Creset %gd %Cgreen%aN%Creset %gs %s"; }
cdot() { pushd_ "${DOTFILES}"; }
cdj() { pushd_ "${HOME}/repos/jwfearn/$1"; }
cdo() { pushd_ "${HOME}/repos/other/$1"; }
cdor() { pushd_ "${HOME}/repos/other_roku/$1"; }
cdg() { cdj 'graph-ruby'; }
cdr() { cdj 'resume'; }
cdi() { cdj 'whiteboard'; }
cdul_() { cd "/usr/local/$1"; }
cdull() { cdul_ "lib/$1"; }
cdulb() { cdul_ "bin/$1"; }
cdt() { cd '/Users/john/repos/other/release_training_elixirconf_2019/2_configuring_a_release/exercise/phx_example_app'; }

pgi() { cdi; psql -W -U postgres termfront_dev "$@"; }
psqld() { psql --host=localhost --port=5432 "$@"; }

## BEGIN: Avvo-related functions
agems() {
  gem list \
    --remote \
    --clear-sources \
    --source "https://${PACKAGECLOUD_READ_TOKEN}@packagecloud.io/avvo/gems" \
    "$@";
}


# xprods() {
#   parallel -q -j 7 \
#   ssh -i ~/.ssh/id_rsa.deployer deployer@{}.prod.avvo.com sh -c \
#   'hostname && /usr/local/rvm/bin/rvm-exec -- ' "$@" \
#   ::: sv1wow sv2wow sv3wow sv4wow amos5wow amos6wow amos7wow amos8wow
# }

hosts_() {
  local HOSTS="$1"; shift
  local SUFFIX="$1"; shift
  local CMD="$@"
  parallel -q -j 7 \
    ssh -i ~/.ssh/id_rsa.deployer "deployer@{}${SUFFIX}" sh -c \
    'hostname;' "${CMD}" \
    ::: ${HOSTS}
}

prods() { hosts_ 'amos5wow amos6wow amos7wow amos8wow api1wad api2wad sv1wow sv2wow sv3wow sv4wow util3wad util4wad' '.prod.avvo.com' "$@"; }
stags() { hosts_ 'sv1stag sv2stag util2stag' '' "$@"; }

prodsb() { prods '/usr/local/rvm/bin/rvm-exec -- bundle -v'; }
prodsrb() { prods '/usr/local/rvm/bin/rvm-exec -- ruby -v'; }
prodsbash() { prods 'bash --version | head -1'; }

stagsb() { stags '/usr/local/rvm/bin/rvm-exec -- bundle -v'; }
stagsrb() { stags '/usr/local/rvm/bin/rvm-exec -- ruby -v'; }
stagsbash() { stags 'bash --version | head -1'; }

uatmon() { open 'xxx' "$@"; } # kafkamon for UAT
ec2ssh_() { cdc && "bin/deploy" vpc ssh "$1" "$2"; }
uatdb() { ec2ssh_ henry61 db; } # mysql, kafka, ...
uatfe() { ec2ssh_ henry61 frontend; } # switchboard, ...
uatbe() { ec2ssh_ henry61 backend; } # stranger-forces, ...
uatin() { ec2ssh_ henry61 internal; }
# stagdb() { ssh db1stag.corp.avvo.com; } # mysql, kafka, ...
# stagfe() { ; } # switchboard, ...
# stagbe() { ; }
# stagin() { ; }
zstag() { "$@"; }
kstag() { "$@"; }

exj() { cd "${HOME}/Exercism/java/" && docker run -it gradle:jdk11; }

ef() { exercism fetch elixir; }
et() { elixir ./*_test.exs; }
kp() {
  pidfiles=($(find . -name 'server.pid'))
  for pidfile in ${pidfiles[@]}; do
    read pid <"${pidfile}"
    kill "${pid}" && echo "killed: ${pid}"
  done
}
mrel() {
  git checkout release \
    && git remote update -p \
    && git merge --ff-only "@{u}" \
    && git checkout master \
    && git merge --ff-only "@{u}" \
    && git merge --no-ff release -m "Merge branch 'release' into 'master'" \
    && git checkout release \
    && git merge master \
    && git push \
    && git checkout master \
    && git push;
}
## END: Avvo-related functions

ngrokw() { ngrok http 3000 "$@"; }

# sha_() { cdc; bx knife ssh "role:$1 AND environment:production" -x ec2-user -a ipaddress 'cd /opt/apptentive/current && git rev-parse HEAD'; popd_; }
# shaa() { sha_ 'web'; }
# shab() { sha_ 'web-be'; }

doki() {
  bundle exec rake templates
  npm run compile-tests
  bundle exec foreman start
}


## Bundler-related functions
bcinfo() { cat ~/.bundle/config 2> /dev/null; cat .bundle/config 2> /dev/null; }
binfo() { bundle list; bcinfo; bundle config "$@"; }
brm() { rm -rf vendor/bundle binstubs "$@"; }
# bi() { bundle install --standalone --path=vendor/bundle --binstubs=binstubs --full-index --jobs 4 "$@"; }
bi() { bundle install --standalone --path=vendor/bundle --binstubs=binstubs "$@"; }
biu() { rm Gemfile.lock; bi "$@"; }
#bspec() { binstubs/rspec "$@"; } # why doesn't thins work for 'web' project?
bx() { bundle exec "$@"; }
# bxprod() { MONGODB_URI='mongodb://mongo/apptentive_production' bx "$@"; }
bo() { bundle outdated | grep "  * " | sort > "${HOME}/_out/outdated.txt"; }
bu() { bundle update "$@"; bi; }
bv() { bx bundle viz -f doc/gem_graph -F svg "$@"; }
bco() { bundle console "$@"; }
brb() { bx irb "$@"; } # use when bco fails
bry() { bx pry "$@"; }

## Rake-related functions
rk() { bundle exec rake -G "$@"; }
rkt() { bundle exec rake -T "$@"; }
rkta() { bundle exec rake -T -A "$@"; }
trk() { RAILS_ENV=test bundle exec rake "$@"; } # -G?

## Test-related functions
spec_() { time bx rspec --color "$@"; }
spec() { bx hound "$@" && spec_ "$@"; }
# bprep() { RAILS_ENV=test bundle exec rake db:prepare; }
rtest() { bx ruby -I"lib:test" "$@"; }
rtesta() { time RAILS_ENV='test' bundle exec rake test; }
# rtesta() { RAILS_ENV=test TESTOPTS='--profile' time bundle exec rake test; }
mtbi() { bundle exec minitest_bisect --seed=$1 -Itest $(find test -type f -name \*_test.rb); } # requires minitest-bisect gem
cb() { circleci build; }
cbu() { circleci version && circleci update && circleci version; }

bjsp() { bx ruby -e 'require "execjs"; ExecJS.runtime'; }

## Rails-related functions
ra() { bx rails "$@"; }
rac() { ra console "$@"; }
ras() { ra server "$@"; }

ggp() { grep bundler/gems/ vendor/bundle/bundler/setup.rb; }
# bfc() { cdf && bi && rk freya:compile; }
midd() { RAILS_ENV='development' bx rake middleware; }
midt() { RAILS_ENV='test' bx rake middleware; }
midp() { RAILS_ENV='production' bx rake middleware; }
# bgp() { bundle config --delete path; bundle config --global path $1/vendor/bundle; }
## Bundler-related aliases for local gem overrides
bon2_() { bundle config "local.$1" "${HOME}/repos/$2"; } # use when gem != project ($1 = gem name, $2 = project name)
bon_() { bundle config "local.$1" "${HOME}/repos/$1"; } # use when gem == project
bon() { bon2_ "$1" "$1"; bundle config; }
# ona() { bon alpha_bits; }
# ond() { bon mozdev; }
# oni() { bon interpol; }
# onl() { bon2_ legion legion-gem; bundle config; }
# onm() { bon mozoo; }
# ons() { bon SSSO; }
# onv() { bon2_ vanguard-client vanguard; bon2_ vanguard-endpoints vanguard; bundle config; }
boff_() { bundle config --delete "local.$1"; }
boff() { boff_ "$1"; bundle config; }
# offa() { boff alpha_bits; }
# offd() { boff mozdev; }
# offi() { boff interpol; }
# offl() { boff legion; }
# offm() { boff mozoo; }
# offs() { boff SSSO; }
# offv() { boff_ vanguard-endpoints; boff vanguard-client; }

## Rubocop-related functions
bcop() { bx rubocop "$@"; bx rubocop --format 'fi' "$@" | wc -l; }
# cop() { bx rubocop -F -c "$HOME/.rubocop.yml" "$@"; }
# hound() { cop $(git diff --name-only); }

## rbenv-related functions
rbenv_() { which rbenv > /dev/null && rbenv "$@"; }
ruby-build_() { which ruby-build > /dev/null && ruby-build "$@"; }
ruby_() { which ruby > /dev/null && ruby "$@"; }
rbs() { ruby-build_ --version; rbenv_ -v; rbenv_ versions; echo "CURRENT RUBY: $(ruby_ -v)"; }
rb+() { rbenv_ install "$1"; }
rb-() { rbenv_ uninstall "$1"; }
rbis_() { ruby-build_ --definitions; }
rbis() { rbis_ | column; }
rbup_() { brew upgrade rbenv 2> /dev/null; brew upgrade ruby-build 2> /dev/null; rbenv_ -v; ruby-build_ --version; }
rbup() { rbis_ > rbis0.txt; rbup_; rbis_ > rbis1.txt; gdiff rbis0.txt rbis1.txt; }
rb0() { rbenv_ local system; rbs; }
rb2() { rbenv_ local 2.7.1; rbs; }
rbj() { rbenv_ local jruby-9.2.5.0; rbs; }
rbe() { rbenv_ each "$@"; }
rgs() { rbenv_ each -v gem list; }
rg+() { rbenv_ each -v gem install "$@"; }
rg-() { rbenv_ each -v gem uninstall "$@"; }
rgo() { rbenv_ each -v gem outdated; return 0; }
rgu() { rbenv_ each -v gem update "$@"; rbenv each -v gem cleanup "$@"; }
rbig() { local cc=$CC; export CC=gcc; rbi "$1"; export CC="${cc}"; } # if rbi does not work, try this
gemup() {
  gem list > gems0.txt
  gem update --no-document
  # install global bundler gem
  gem install --no-document bundler
  # install global gems needed for JetBrains debugging
  gem install --no-document debase debase-ruby_core_source ruby-debug-ide
  gem cleanup
  rbenv_ rehash
  hash -r
  gem list > gems1.txt
  gdiff gems0.txt gems1.txt
}

## jenv-related functions
js() { jenv --version; jenv versions; echo 'CURRENT JAVA:'; java -version; }
j0() { jenv local system; js; }
j8() { jenv local oracle64-1.8.0.60; js; }

## Python-related functions
python3_() { which python3 > /dev/null && python3 "$@"; }
pip3_() { which pip3 > /dev/null && pip3 "$@"; }
pps() { pip3_ list "$@"; }
ppo() { pip3_ list --outdated "$@"; return 0; }
ppu() { pip3_ list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U; }


## MySQL-related functions
mystart_dot() { mysql.server start "$@"; }
mystop_dot() { mysql.server start "$@"; }
myrestart_dot() { mysql.server start "$@"; }
mystart_brew() { brew services start mysql56 "$@"; }
mystop_brew() { brew services stop mysql56 "$@"; }
myrestart_brew() { brew services restart mysql56 "$@"; }
mystart() { mystart_brew "$@"; }
mystop() { mystop_brew "$@"; }
myrestart() { myrestart_brew "$@"; }
my() { mysql -uroot -p "$@"; }
mystag() {
  mysql \
    "--host=${DB_HOST_STAG}" \
    "--port=${DB_PORT_STAG}" \
    "--user=${DB_USER_STAG}" \
    "--password=${DB_PASS_STAG}" \
    "$@";
}
# my() { /usr/local/mysql/bin/mysql; }
# myd() { /usr/local/mysql/bin/mysql server start; }
# myad() { /usr/local/mysql/bin/mysqladmin; }
# myp() { /usr/local/mysql/bin/mysqladmin -u root -p status; }
# myfix() { sudo ln -ssudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib; }

## Redis-related functions
redd() { redis-server "$@"; }
redc() { redis-cli "$@"; }

## MongoDB-related functions
mdbs() { mongo --eval show dbs; }
# mprod() { mongo mongo.corp.apptentive.com:27017/apptentive_production "$@"; }
# mdev() { mongo localhost:27017/apptentive_development "$@"; }
# xmprod() { mongo --host mongo.corp.apptentive.com --port 27017 apptentive_production "$@"; }
# rr() { bx railroady -vbamM | sed -E 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | dot -Tsvg > rr.svg; }

## JetBrains-related functions
ul_() { s="$@"; echo -e "\n$(tput smul)${s}$(tput sgr0)"; }
jbplugins() { d=$(cd ~/Library/Application\ Support/IntelliJIdea*; pwd); ul_ "JetBrains Plugins: ${d}"; ls "$@" "${d}" ; }
jbprefs() { d=$(cd ~/Library/Preferences/IntelliJIdea*; pwd); ul_ "JetBrains Preferences: ${d}"; ls "$@" "${d}" ; }
jbcaches() { d=$(cd ~/Library/Caches/IntelliJIdea*; pwd); ul_ "JetBrains Caches: ${d}"; ls "$@" "${d}" ; }
jblogs() { d=$(cd ~/Library/Logs/IntelliJIdea*; pwd); ul_ "JetBrains Logs: ${d}"; ls "$@" "${d}" ; }
jbfiles() { jbplugins "$@"; jbprefs "$@"; jbcaches "$@"; jblogs "$@"; }

## Capistrano-related functions
dfd() { cdf && bx cap dev deploy; }

## Amazon Web Services-related functions
adate() { curl -0 -i http://s3.amazonaws.com/; }

cecho() { tput setab "$1" && echo -n "$1" && tput setab 0; }
# setab = Set background color using ANSI escape
# setaf = Set foreground color using ANSI escape

## SEARCH FUNCTIONS
the_silver_searcher() {
  echo "use the 'ag' command to use the_silver_searcher.  See also: https://github.com/ggreer/the_silver_searcher"
}

ffgit() { git ls-files "$@"; } # TODO: recursively list git files matching a pattern
ff() { find . -type f \( -name '' -or -name "$@" \); } # recursively list all files matching a pattern
findpy() { ff '*.py'; }
findrb() { ff '*.rb'; }
# TODO: refactor findcpp
findcpp() { find . -type f \( -name '' -or -name '*.h' -or -name '*.hpp' -or -name '*.hxx' -or -name '*.c' -or -name '*.cc' -or -name '*.cpp' -or -name '*.cxx' \); }

lsx() { "$@"; }

fxall() { find . -type f -perm +111 -print "$@"; } # recursively list all files with executable permission
fx() { fxall | grep -v '.git/'; } # TODO: recursively list git files with executable permission
-x() { chmod -x $(fx); } # recursively remove executable permission from git files
# -x() { chmod -x $(git ls-files); } # recursively remove executable permission from git files
yellow_() { find . -type d -perm +22 "$@"; }
yellow() { yellow_ -print "$@"; }
-yellow() { chmod =rw+x $(yellow_); }

gitls() { git ls-tree --name-only --full-tree -r HEAD; }

findin() { # print lines
  local pattern="${1}"
  local glob="${2}"
  # use rg because it has globbing
  rg "${pattern}" "${glob}"
}

findwith() { # print file paths only
  local pattern="${1}"
  local glob="${2}"
  # use rg because it has globbing
}

_grb() { grep -r --include "*.rb" "$@" .; }
# grb() { _grb --exclude-dir=vendor "$@"; }
# grbv() { _grb --include-dir=vendor "$@"; } # TODO
rbg() { ag --stats --ruby "$@" .; } # honors .gitignore, et al
# grbv() { "$@"; } # TODO
eg() { env | sort | ag "$@"; }

xgrep_in_bash_profiles() {
  local profiles=('/etc/profile' '/etc/bash.bashrc' "${HOME}/.bashrc" "${HOME}/.bash_profile" "${HOME}/.bash_login" "${HOME}/.profile")
  for profile in ${profiles[@]}; do
    echo "${profile}"
  done
}

grep_in_bash_profiles() {
  local profiles="/etc/profile /etc/bash.bashrc ${HOME}/.bashrc ${HOME}/.bash_profile ${HOME}/.bash_login ${HOME}/.profile"
  grep -s "$1" "${profiles}"
}

# fn_code_str() { echo $(type ${1}); }

xenvp_() {
  for k in "$@"; do
    local v
    v=$(eval "\${${k}}")
    if [ -z "${v}" ]; then
      echo "${k}    [not present]"  #TODO: dim not set
    else
      echo "${k}='${v}'"
    fi
  done
}

envp_() {
  # each arg k is an environment variable name
  # for each k:
  #   if k has a value, echo k and $k in 'set' setyle
  #   otherwise echo k 'not set' setyle
  local DIM='\033[1;30m'
  local BRIGHT='\033[32m'
  local RESET='\033[0m'
  for k in "$@"; do
    local s
    s=$(env | sort | grep "^${k}=")
    if [ -z "${s}" ]; then
      echo -e "${DIM}${k}${RESET}\n"
    else
      echo -e "${BRIGHT}${s}${RESET}\n"
    fi
  done
}

filesp_() {
  # each arg f is an absolute file path
  # for each f:
  #   if f exists, echo f in 'present' style
  #   otherwise echo f in 'not present'
  local DIM='\033[1;30m'
  local BRIGHT='\033[32m'
  local RESET='\033[0m'
  for f in "$@"; do
    local style="${DIM}"
    [ -f "${f}" ] && style="${BRIGHT}"
    echo -e "${style}${f}${RESET}\n"
  done
}

bashprofiles_() {
  echo /etc/profile /etc/bash.bashrc ~/.bashrc ~/.bash_profile ~/.bash_login ~/.profile ~/.bash_logout
}

zshprofiles_() {
  echo /etc/zshenv ~/.zshenv /etc/zprofile ~/.zprofile /etc/zshrc ~/.zshrc /etc/zlogin ~/.zlogin ~/.zlogout /etc/zlogout
}

bashi() {
  bash --version
  filesp_ "$(bashprofiles_)"
  envp_ BASH_ENV # UNSET BLANK SPACE X
}

zshi() {
  zsh --version
  filesp_ "$(zshprofiles_)"
}

rc() { e "${DOTFILES}/jffn.sh"; }
src() { . "${DOTFILES}/jffn.sh"; }  # reload function only
srcx() { . "${DOTFILES}/jfenv.sh"; src; }  # also reload environment variables
colors() { bash "${DOTFILES}/bin/colortest.sh"; }
minr() { ruby "${DOTFILES}/bin/minrails.rb"; }

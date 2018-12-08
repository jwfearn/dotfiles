#! /usr/bin/env sh

# shellcheck disable=SC2039

# cd /mnt/cluster/bh/work/; s=$(cat shard.id); ls -d xA*/*.stack 2> /dev/null | xargs -I% egrep -o -m1 '"bestPartitions":"[^"]*"' % | sed "s/\"//g" | sed "s/bestPartitions://g" | xargs -I% echo "$(cat %)"
# amexample() { curl -u "$APP_MONSTA_KEY:X" 'https://api.appmonsta.com/v1/stores/itunes/details/450432947.json?country=ALL' | jq '.'; }

## aliases
alias 'cd..'='cd ..' # 'cd..' cannot be a function name
alias 'cd...'='cd ../..'
alias 'cd....'='cd ../../..'
alias 'cd.....'='cd ../../../..'
alias 'cd-'='cd -'
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
myip() { ipconfig getifaddr en0; }
mycores() { sysctl -n hw.physicalcpu; }

q() { mysql -p -uroot "$@"; }

anyrspec1() { find "${1:-.}" -type f -name '*_spec.rb' | head -1; } # fast
anyrspec2() { find "${1:-.}" -type f -name '*_spec.rb' \( -exec echo {} \; -quit \) 2> /dev/null; } # faster
anyrspec3() { find "${1:-.}" -name '*_spec.rb' -print -quit; } # faster, simpler
anyrspec4() { compgen -G 'spec/**/*_spec.rb'; } # fastest but not ZShell-compatible

t() {
  if [ -f 'mix.exs' ]; then # ExUnit
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

yt() {
  pushd "${HOME}/repos/avvo/scooter/apps/scooter_web/assets"
  yarn test "$@"
  popd
}

whilepass() { while $1; do :; done; }
whilefail() { while ! $1 ; do :; done; }

vt() { TESTOPTS='--verbose' t "$@"; }

ls() { env ls -aF "$@"; }
l() { ls "$@"; }
ll() { ls -l "$@"; }

man() {
  env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    man "$@"
}

# prt() { lsof -n -i4TCP:$1 | grep LISTEN; }

## Linkscape-related functions
# alias sx_="echo url{1..10} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
# alias sxk_="echo url{1..10} | tr ' ' '\n' | xargs -I^ ssh ^ "
# schk() { sx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_urlsched)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
# sstop() { sx_   ; }
# sstart() { sx_ 'cd /mnt/cluster/bh/work && ./start_crawler'; }
# srestart() { sx_ 'cd /mnt/cluster/bh/work && touch Restart && ./start_crawler'; }
# sxf_() { parallel --no-notice -k --bar "parallel --no-notice -S url{} -n0 --transfer ::: 1" ::: {1..10}; }
# sxf_() { local f=$1; shift; parallel --no-notice "$@" "parallel --no-notice -S 1/url{} --transfer --cleanup bash ::: $f" ::: {1..10}; }
# cxf_() { local f=$1; shift; parallel --no-notice -k "$@" "parallel --no-notice -S 1/crawl{} --transfer --cleanup bash ::: $f" ::: {1..20}; }
# sxfn_() { local fn=$1 && export -f $fn && parallel --no-notice -k --bar "parallel --no-notice -S 1/url{} -n0 --env $fn $fn ::: 1" ::: {1..10}; }
# cxfn_() { local fn=$1 && export -f $fn && parallel --no-notice -k --bar "parallel --no-notice -S 1/crawl{} -n0 --env $fn $fn ::: 1" ::: {1..20}; }
# cck() { date; cxfn_ cstat; }
# sck() { date; sxfn_ sstat; }
# cck() { date; pushd . > /dev/null; cdl; cxf_ scripts/cstat.sh "$@"; popd > /dev/null; }
# sck() { date; pushd . > /dev/null; cdl; sxf_ scripts/sstat.sh "$@"; popd > /dev/null; }
# cck() { cdl && scripts/crawlers_status "$@"; }
# sck() { cdl && scripts/schedulers_status "$@"; }
# findbad() {
#   ls -Sr *.lzoc | head -5 | xargs -P$(($(nproc) - 1)) -I^ ../bin/copystream ^ - >& /dev/null && echo 'GOOD: ^' || echo 'BAD: ^';
# }
# alias cx_="echo crawl{1..20} | tr ' ' '\n' | xargs -P20 -I^ ssh ^ "
# alias cxk_="echo crawl{1..20} | tr ' ' '\n' | xargs -I^ ssh ^ "
# alias tx_="echo ctest{A..C} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
# alias txk_="echo ctest{A..C} | tr ' ' '\n' | xargs -I^ ssh ^ "

# JF_VERSIONS_CMD=' \
#     echo ^: \
#     $(lsb_release -sd), \
#     $(gcc --version | head -1), \
#     $(grep BOOST_LIB_VERSION /usr/include/boost/version.hpp | tail -1) \
# '
#     # $(git --version), \
#     # $(bash --version | head -1), \
#     # $(make --version | head -1), \
#     # $(gdb --version 2> /dev/null | head -1) \

# tcc() { txk_ "${JF_VERSIONS_CMD}"; }
# ccc() { cxk_ "${JF_VERSIONS_CMD}"; }
# scc() { sxk_ "${JF_VERSIONS_CMD}"; }

# cpi() { cxk_ 'echo ^: $(initctl status procinfo >& | xargs)'; }
# spi() { sxk_ 'echo ^: $(initctl status procinfo >& | xargs)'; }
# cpyenvs() { cxk_ 'echo ^: $(ls -d /mnt/cluster/bh/work/.pyenv/bin ~/.pyenv/bin 2> /dev/null)'; }
# spyenvs() { sxk_ 'echo ^: $(ls -d /mnt/cluster/bh/work/.pyenv/bin ~/.pyenv/bin 2> /dev/null)'; }
# alias cxs_="echo crawl{1..20} | tr ' ' '\n' | xargs -I^ ssh ^ "
# cchk() { date; cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler), async-dirs: $(ls -ld /mnt/cluster/bh/work/Async-* 2> /dev/null | wc -l), async-ps: $(ps -ef | grep -v grep | grep crawlv2loop | grep Async | wc -l)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
# cchk() { date; cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler), async-dirs: $(find Async-* -maxdepth 0 -type d -print 2> /dev/null | wc -l), async-ps: $(ps -ef | grep -v grep | grep crawlv2loop | grep Async | wc -l)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
# cchk() { cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler)"'; }
# casynp() { cx_ 'a=$(ls -d /mnt/cluster/bh/work/Asy* 2>/dev/null | wc -l);echo "^ $a"'; }
# cstop() { cx_ 'touch /mnt/cluster/bh/work/Stop'; }
# cstart() { cx_ 'cd /mnt/cluster/bh/work && ./start_crawler'; }
# lln() { cx_ 'cd /mnt/cluster/bh/bin && ln -s ../src/release/processing/canonicalize .'; }
# lbr() { cx_ 'cd /mnt/cluster/bh/src && git branch'; }
# alias fx_="echo dfix{0..9} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
# fxpull() { fx_ 'cd /mnt/cluster/bh/src && git checkout SAVANNA-2737-transfer-fix-script && git pull'; }
#  echo fixer{0..9} | tr ' ' '\n' | xargs -P10 -I^ scp root@^:/mnt/log/fixtransfers_*.log ./^logs/
# cps() { cd ~/repos/linkscape/scripts/ && scp steps.py requirements.txt va:/mnt/cluster/bh/src/scripts/; }
# cps() { echo crawl{1..20} | tr ' ' '\n' | xargs -P20 -I^ scp ~/Save ^:~;  }
# cps() { cd ~/repos/linkscape/scripts/ && scp steps.py requirements.txt crawl1:/mnt/cluster/bh/src/scripts/; }

# filterpath() {
#   local readonly oldpath="${PATH}"
#   local readonly newpath=oldpath
#   export PATH="${newpath}"
# }

# abspath() {
#   local readonly p="${1}"
#   local absp=''
#   # if [ -f "${p}" ]; then
#   #   absp="$(cd $(dirname "${p}") && pwd)/$(basename "${p}")"
#   # elif [ -d "${p}" ]; then
#   #   absp="$(cd "${p}" && pwd)"
#   # fi
#   echo "${absp}"
# }

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


## Homebrew-related functions
o() { vpu && ppo && rgo && bod; }
bod() { brew update && brew outdated && brew doctor; }
buc() { brew upgrade; brew cleanup; }
bs() { brew services "$@"; }
bss() { brew services list "$@"; }

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
dirb() { find "$(pwd)" -depth 1 "$@"; }

## general purpose shell functions
disks() { diskutil list; }
ts() { date +"%s"; }
vars() { env | sort -V; }
ei() { env | sort | grep "$@"; }
e() { subl "$@"; }
h() { history | tail -"$1"; }
lsl() { env ls -lOeF "$@"; }  # -O is a Mac-specific option
lsd() { env ls -d .*/ "$@"; }
lsb() { find "$@"; }  # bare directory listing (like DOS: `dir /b`)
lsapts() {
  local F='/etc/apt/sources.list'
  local D="${L}.d"
  [ -f ${F} ] && lsb ${F}; [ -d "${D}" ] && lsb "${D}"
}
pushd_() { pushd "$@" > /dev/null; }
popd_() { popd "$@" > /dev/null; }
posh() { powershell "$@"; }

lk() { open -a ScreenSaverEngine; }
path() { echo "${PATH}" | tr ':' '\n'; }
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

# modo() {}  # TODO: get permissions as octal string


# `ps -ef` header row:
# UID        PID  PPID  C STIME TTY          TIME CMD
# `ps -ely` header row:
# S   UID   PID  PPID  C PRI  NI   RSS    SZ WCHAN  TTY          TIME CMD
#
#   S = minimal state display (one of: DRSTWXZ)
#   UID = effective user ID
#   PID = process ID
#   PPID = parent process ID
#   C = processor utilization integer
#   PRI = priority, higher number means lower priority
#   NI = nice value. This ranges from 19 (nicest) to -20 (not nice to others)
#   RSS = resident set size (KB), non-swapped physical memory task has used
#   SZ = approximate amount of swap space
#   WCHAN = address of the kernel where the process is sleeping
#   STIME = xxx
#   TTY = terminal associated with process
#   TIME = cumulative CPU time, "[dd-]hh:mm:ss" format.
#   CMD = command name (only the executable name).
#
# `ps -ef` example data row:
# martin     379 28712  0 Feb24 pts/3    00:00:01 mysql -u Moz -p Moz
# `ps -ely` example data row:
# S  1000  3764  3348  0  80   0  3208 19739 poll_s pts/3    00:00:00 jshd


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

## Roku-related functionsv
vk() { docker-compose run shell invoke "$@"; }
vx() { docker-compose run shell "$@"; }
vb() { docker-compose build "$@"; }
vrb() { docker-compose build --no-cache "$@"; }

# Roku xxx (as JSON)
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
nr() { npm run "$@"; }
nt() { npm test "$@"; }

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
vps() { vagrant plugin list "$@"; }
vinfo() { vagrant version; vps; vagrant global-status; vagrant status "$@" 2> /dev/null; }
vbo() { vagrant box outdated "$@"; }
vbs() { vagrant box list -i "$@"; }
vbu() { vagrant box update "$@"; }
vpu() {
  if [ $(which vagrant > /dev/null) ]; then
    vagrant plugin list && vagrant plugin update "$@"
    vagrant version
  fi
}

# vsh() { vagrant ssh "$@"; }
# vu() { v up --provider=vmware_fusion && vsh "$@"; }
vu() { vagrant up "$@"; }
vhelp() { vagrant help "$@"; }
vsus() { vagrant suspend "$@"; }
vsw() { vsus "$1" && vush "$2"; }
vd() { vagrant destroy -f "$@"; }
vl() { vagrant reload "$@"; }
vdu() { vd "$@" && vu "$@"; }
vush() { vu "$@" && vsh "$@"; }
vdush() { vd "$@" && vush "$@"; }
vrps() { vagrant reload --provision "$@" && vsh "$@"; }  # faster than vdus?
cdvp() { cd "${HOME}/vagrant/processing"; vp; }
cdvd() { cd "${HOME}/vagrant/boot2docker"; vp; }
cdvw() { cd "${HOME}/vagrant/vmwtest/"; }
cdvb() { cd "${HOME}/vagrant/vbtest/"; }

## Git-related functions
gi() { git status; git --version; }
gdiff_() { local b0="$1"; local b1="$2"; shift 2; git diff --color --minimal "${b0}..${b1}" "$@"; }
gstat_() { local b0="$1"; local b1="$2"; shift 2; git diff --color --minimal --stat "${b0}..${b1}" "$@"; }
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
cdg() { cdj 'graph-ruby'; }
cdn() { cdo 'nand2tetris2017/jwfearn'; }
cdr() { cdj 'resume'; }
cdi() { cdj 'whiteboard'; }
cdul_() { cd "/usr/local/$1"; }
cdull() { cdul_ "lib/$1"; }
cdulb() { cdul_ "bin/$1"; }
# cdt() { cd "${HOME}/_out/bhtmp/repo/"; }

pgi() { cdi; psql -W -U postgres termfront_dev "$@"; }

## BEGIN: Hulu-related functions
cdw() { pushd_ "${HOME}/repos/hulu/$1"; }
cdb() { cdo brs; }
cdc() { cdw cube-roku; }
## END: Hulu-related functions

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
rb+() { rbenv install "$1"; }
rb-() { rbenv uninstall "$1"; }
rbis_() { ruby-build --definitions; }
rbis() { rbis_ | column; }
rbup_() { brew upgrade rbenv 2> /dev/null; brew upgrade ruby-build 2> /dev/null; rbenv -v; ruby-build --version; }
rbup() { rbis_ > rbis0.txt; rbup_; rbis_ > rbis1.txt; gdiff rbis0.txt rbis1.txt; }
rbs() { rbenv -v; ruby-build --version; rbenv versions; echo "CURRENT RUBY: $(ruby -v)"; }
rb0() { rbenv local system; rbs; }
rb2() { rbenv local 2.5.3; rbs; }
rb25() { rbenv local 2.5.3; rbs; }
rb251() { rbenv local 2.5.1; rbs; }
rb24() { rbenv local 2.4.3; rbs; }
rb243() { rbenv local 2.4.3; rbs; }
rb23() { rbenv local 2.3.6; rbs; }
rb236() { rbenv local 2.3.6; rbs; }
rb22() { rbenv local 2.2.9; rbs; }
rb221() { rbenv local 2.2.1; rbs; }
rb223() { rbenv local 2.2.3; rbs; }
rb226() { rbenv local 2.2.6; rbs; }
rb229() { rbenv local 2.2.9; rbs; }
rb21() { rbenv local 2.1.10; rbs; }
rb2110() { rbenv local 2.1.10; rbs; }
rbj() { rbenv local jruby-9.1.13.0; rbs; }
rbe() { rbenv each "$@"; }
rgs() { rbenv each -v gem list; }
rg+() { rbenv each -v gem install "$@"; }
rg-() { rbenv each -v gem uninstall "$@"; }
rgo() { rbenv each -v gem outdated; }
rgu() { rbenv each -v gem update "$@"; rbenv each -v gem cleanup "$@"; }
rbig() { local cc=$CC; export CC=gcc; rbi "$1"; export CC="${cc}"; } # if rbi does not work, try this
gup() {
  gem list > gems0.txt
  gem update --no-document
  # install global bundler gem
  gem install --no-document bundler
  # install global gems needed for JetBrains debugging
  gem install --no-document debase debase-ruby_core_source ruby-debug-ide
  gem cleanup
  rbenv rehash
  hash -r
  gem list > gems1.txt
  gdiff gems0.txt gems1.txt
}

## jenv-related functions
js() { jenv --version; jenv versions; echo 'CURRENT JAVA:'; java -version; }
j0() { jenv local system; js; }
j8() { jenv local oracle64-1.8.0.60; js; }

## pyenv-related functions
pys() { pyenv --version; pyenv versions; echo "CURRENT PYTHON: $(python --version 2>&1)"; }
pyis_() { pyenv install --list "$@"; }
pyis() { pyis_ | column; }
py+() { pyenv install "$1"; }
py-() { pyenv uninstall "$1"; }
pyup() { pyis_ > pyis0.txt; brew upgrade pyenv; pyis_ > pyis1.txt; gdiff pyis0.txt pyis1.txt; }
py0() { pyenv local system; pys; }
py2() { pyenv local 2.7.15; pys; }
py3() { pyenv local 3.7.1; pys; }
pya() { pyenv local anaconda3-5.0.1; pys; }
ppu() { which pyenv > /dev/null && pyenv pip-update "$@"; }
ppo() { which pip > /dev/null && pip list --outdated "$@"; }

#pyl() { pyenv local linkscape; }
syspip() { PIP_REQUIRE_VIRTUALENV='' pip "$@"; }
pyx() { local cmd="$@"; local py="from subprocess import check_output as x; o = x('$cmd'); print(o)"; echo $py; python -c"$py"; }
pea() { pyenv activate "$@"; }
ped() { pyenv deactivate "$@"; }
pyv() { pyenv virtualenv "$@"; }

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

findname()  { find . -type f \( -name '' -or -name "$@" \); }
findpy() { findname '*.py'; }
findrb() { findname '*.rb'; }
# TODO: refactor findcpp
findcpp() { find . -type f \( -name '' -or -name '*.h' -or -name '*.hpp' -or -name '*.hxx' -or -name '*.c' -or -name '*.cc' -or -name '*.cpp' -or -name '*.cxx' \); }

gitls() {
  git ls-tree --name-only --full-tree -r HEAD
}

findin() { # print lines
  local pattern="${1}"
  local glob="${2}"
  # use rg because it has globbing
}

findwith() { # print file paths only
  local pattern="${1}"
  local glob="${2}"
  # use rg because it has globbing
}

_grb() { grep -r --include "*.rb" "$@" .; }
# grb() { _grb --exclude-dir=vendor "$@"; }
# grbv() { _grb --include-dir=vendor "$@"; } # TODO
grb() { ag --stats --ruby "$@" .; } # honors .gitignore, et al
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

## Vanguard-related functions
# vcredx_() { cdv && cd config && mv -v credentials.development.yml credentials.test.yml ${HOME}/_out; }
# vcredcp_() { cp -v credentials.development.yml credentials.test.yml; }
# vcred() { vcredx_ && cp -v ${HOME}/Downloads/credentials.development.yml . && vcredcp_; }
# ## Vanguard test manual prerequisites: 1) mysql running, 2) drop local vanguard* schemas, 3) redis-server running
# vun_() { echo UNIT TESTS; bspec spec/unit; }
# vun() { vun_; }
# vun_full() { echo UNIT PREREQUISITES; cdv && bi && br db:recreate_master && vun_; }
#
# vin_() { echo INTEGRATION TESTS; bspec spec/integration; }
# vin() { vun && vin_; }
# vin_full() { vun_full && vin_; }
#
# vsc_() { echo SHARD CREATION TESTS; ulimit -Sn 2048 && bspec spec/acceptance/shard_creation_spec.rb; }
# vsc() { vin && vsc_; }
# vsc_full() { vin_full && vsc_; }
#
# vac_() { echo ACCEPTANCE TESTS; br spec:server:acceptance; }
# vac() { vsc && vac_; }
# vac_full() { vsc_full && vac_; }

## Oyez-related aliases
# omi() { bx sequel -m db/migrate mysql2://root:crash19spit@localhost/oyez_development; }
# odu() { unicorn -d; }
# disabled aliases
# alias fixdir='ruby ${HOME}/bin/fixdir.rb' # fixes unzipped Closure Library files
# alias reclone='ruby ${HOME}/bin/reclone.rb'
# alias tp='ruby ${HOME}/bin/testprj.rb'
# alias tpl='ruby ${HOME}/bin/testprjlocal.rb'
# alias plovr='java -jar ${HOME}/bin/plovr-4b3caf2b7d84.jar'
# alias cb='python ${HOME}/closure-library-read-only/closure/bin/build/closurebuilder.py'
# alias dw='python ${HOME}/closure-library-read-only/closure/bin/build/depswriter.py'
# alias rmpid='rm ${HOME}/repos/freya/tmp/pids/vanguard_stub_app.pid'
# alias cdlb='cd ${HOME}/FOWLER/work/tech/external/lb/lbfork'


rc() { e "${DOTFILES}/jffn.sh"; }
src() { . "${DOTFILES}/jffn.sh"; }  # reload function only
srcx() { . "${DOTFILES}/jfenv.sh"; src; }  # also reload environment variables
colors() { bash "${DOTFILES}/bin/colortest.sh"; }
minr() { ruby "${DOTFILES}/bin/minrails.rb"; }

if [ "${ZSH_VERSION}" ]; then
  source "${DOTFILES}/jffn.zsh"
elif [ "${BASH_VERSION}" ]; then
  source "${DOTFILES}/jffn.bash"
fi

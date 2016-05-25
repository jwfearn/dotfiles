# jffn.sh - may be exectued by bash OR zsh

# cd /mnt/cluster/bh/work/; s=$(cat shard.id); ls -d xA*/*.stack 2> /dev/null | xargs -I% egrep -o -m1 '"bestPartitions":"[^"]*"' % | sed "s/\"//g" | sed "s/bestPartitions://g" | xargs -I% echo "$(cat %)"
amexample() { curl -u "$APP_MONSTA_KEY:X" 'https://api.appmonsta.com/v1/stores/itunes/details/450432947.json?country=ALL' | jq '.'; }

## aliases
alias ls='ls -aF' # cannot be a function or it would infinitely recurse
alias tree='tree -CF' # cannot be a function or it would infinitely recurse
# alias irb='irb --'
alias 'cd..'='cdup' # 'cd..' cannot be a function name
# alias 'cd/'='cdroot' # 'cd..' cannot be a function name


## Linkscape-related functions
# alias sx_="echo url{1..10} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
alias sx_="echo url{1..10} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
alias sxk_="echo url{1..10} | tr ' ' '\n' | xargs -I^ ssh ^ "
# schk() { sx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_urlsched)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
sstop() { sx_ 	; }
sstart() { sx_ 'cd /mnt/cluster/bh/work && ./start_crawler'; }
srestart() { sx_ 'cd /mnt/cluster/bh/work && touch Restart && ./start_crawler'; }
# sxf_() { parallel --no-notice -k --bar "parallel --no-notice -S url{} -n0 --transfer ::: 1" ::: {1..10}; }
sxf_() { local f=$1; shift; parallel --no-notice "$@" "parallel --no-notice -S 1/url{} --transfer --cleanup bash ::: $f" ::: {1..10}; }
cxf_() { local f=$1; shift; parallel --no-notice -k "$@" "parallel --no-notice -S 1/crawl{} --transfer --cleanup bash ::: $f" ::: {1..20}; }
# sxfn_() { local fn=$1 && export -f $fn && parallel --no-notice -k --bar "parallel --no-notice -S 1/url{} -n0 --env $fn $fn ::: 1" ::: {1..10}; }
# cxfn_() { local fn=$1 && export -f $fn && parallel --no-notice -k --bar "parallel --no-notice -S 1/crawl{} -n0 --env $fn $fn ::: 1" ::: {1..20}; }
# cck() { date; cxfn_ cstat; }
# sck() { date; sxfn_ sstat; }
# cck() { date; pushd . > /dev/null; cdl; cxf_ scripts/cstat.sh "$@"; popd > /dev/null; }
# sck() { date; pushd . > /dev/null; cdl; sxf_ scripts/sstat.sh "$@"; popd > /dev/null; }
cck() { cdl && scripts/crawlers_status "$@"; }
sck() { cdl && scripts/schedulers_status "$@"; }

findbad() {
  ls -Sr *.lzoc | head -5 | xargs -P$(($(nproc) - 1)) -I^ ../bin/copystream ^ - >& /dev/null && echo 'GOOD: ^' || echo 'BAD: ^';
}

alias cx_="echo crawl{1..20} | tr ' ' '\n' | xargs -P20 -I^ ssh ^ "
alias cxk_="echo crawl{1..20} | tr ' ' '\n' | xargs -I^ ssh ^ "
alias tx_="echo ctest{A..C} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
alias txk_="echo ctest{A..C} | tr ' ' '\n' | xargs -I^ ssh ^ "

JF_VERSIONS_CMD=' \
    echo ^: \
    $(lsb_release -sd), \
    $(gcc --version | head -1), \
    $(grep BOOST_LIB_VERSION /usr/include/boost/version.hpp | tail -1) \
'
    # $(git --version), \
    # $(bash --version | head -1), \
    # $(make --version | head -1), \
    # $(gdb --version 2> /dev/null | head -1) \

tcc() { txk_ "${JF_VERSIONS_CMD}"; }
ccc() { cxk_ "${JF_VERSIONS_CMD}"; }
scc() { sxk_ "${JF_VERSIONS_CMD}"; }

cpi() { cxk_ 'echo ^: $(initctl status procinfo >& | xargs)'; }
spi() { sxk_ 'echo ^: $(initctl status procinfo >& | xargs)'; }
cpyenvs() { cxk_ 'echo ^: $(ls -d /mnt/cluster/bh/work/.pyenv/bin ~/.pyenv/bin 2> /dev/null)'; }
spyenvs() { sxk_ 'echo ^: $(ls -d /mnt/cluster/bh/work/.pyenv/bin ~/.pyenv/bin 2> /dev/null)'; }
# alias cxs_="echo crawl{1..20} | tr ' ' '\n' | xargs -I^ ssh ^ "
# cchk() { date; cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler), async-dirs: $(ls -ld /mnt/cluster/bh/work/Async-* 2> /dev/null | wc -l), async-ps: $(ps -ef | grep -v grep | grep crawlv2loop | grep Async | wc -l)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
# cchk() { date; cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler), async-dirs: $(find Async-* -maxdepth 0 -type d -print 2> /dev/null | wc -l), async-ps: $(ps -ef | grep -v grep | grep crawlv2loop | grep Async | wc -l)  $(cd /mnt/cluster/bh/work && ls -C STOP Stop Quit Restart Start 2> /dev/null)"'; }
# cchk() { cx_ 'echo "${HOSTNAME}: jshd: $(pgrep -c jshd), script: $(pgrep -c start_crawler)"'; }
casynp() { cx_ 'a=$(ls -d /mnt/cluster/bh/work/Asy* 2>/dev/null | wc -l);echo "^ $a"'; }
cstop() { cx_ 'touch /mnt/cluster/bh/work/Stop'; }
cstart() { cx_ 'cd /mnt/cluster/bh/work && ./start_crawler'; }
lln() { cx_ 'cd /mnt/cluster/bh/bin && ln -s ../src/release/processing/canonicalize .'; }
lbr() { cx_ 'cd /mnt/cluster/bh/src && git branch'; }
alias fx_="echo dfix{0..9} | tr ' ' '\n' | xargs -P10 -I^ ssh ^ "
fxpull() { fx_ 'cd /mnt/cluster/bh/src && git checkout SAVANNA-2737-transfer-fix-script && git pull'; }
#  echo fixer{0..9} | tr ' ' '\n' | xargs -P10 -I^ scp root@^:/mnt/log/fixtransfers_*.log ./^logs/
# cps() { cd ~/github/linkscape/scripts/ && scp steps.py requirements.txt va:/mnt/cluster/bh/src/scripts/; }
cps() { echo crawl{1..20} | tr ' ' '\n' | xargs -P20 -I^ scp ~/Save ^:~;  }
# cps() { cd ~/github/linkscape/scripts/ && scp steps.py requirements.txt crawl1:/mnt/cluster/bh/src/scripts/; }

filterpath() {
  local readonly oldpath=${PATH}
  local readonly newpath=oldpath
  export PATH=${newpath}
}

abspath() {
  local readonly p=${1}
  local absp=''
  # if [[ -f "${p}" ]]; then
  #   absp="$(cd $(dirname "${p}") && pwd)/$(basename "${p}")"
  # elif [[ -d "${p}" ]]; then
  #   absp="$(cd "${p}" && pwd)"
  # fi
  echo "${absp}"
}

pathpp() {
  saveIFS=${IFS}
  IFS=":"
  for segment in ${PATH}; do
    if [[ -d "${segment}" ]]; then
      segment="$(cd ${segment} && pwd)"
      echo "${segment}"
    fi
  done
  IFS=${saveIFS}
}

pathhas() {  # return 0 if path contains d
  local ret=1
  local readonly d=$1  #TODO ensure d is expanded to absolute path
  saveIFS=${IFS}
  IFS=":"
  for segment in ${PATH}; do
    if [[ ${segment}  ]]; then  #TODO ensure segment is expanded to absolute path
      ret=0
      break
    fi
  done
  IFS=${saveIFS}
  return ${ret}
}

# pathadd() { # add to path only if not already there
#   local readonly d=$1
# }

pathadd() {
  local readonly d="$(cd $1 && pwd)"
  if [[ -d "${d}" ]] && [[ ":${PATH}:" != *":${d}:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}


pathrm() { # remove all path segments matching pattern (filename matching rules)
  $pattern=$1
}


tunnelthor() { ssh -L 7706:localhost:3306 -p 2022 root@zabbix.seomoz.org; }
cmux() { lmux.sh crawl 20; }
pmux() { lmux.sh processing xxx; }
smux() { lmux.sh url 10; }


## Homebrew-related functions
bod() { brew update && brew outdated && brew doctor; }
buc() { brew upgrade --all; brew cleanup; }

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
cdroot() { cd /; }
cls() { clear; }
dir() { ls "$@"; }
dirb() { find "$(pwd)" -depth 1 "$@"; }

## general purpose shell functions
vars() { env | sort -V; }
ep() { env | sort | grep "$@"; }
e() { subl "$@"; }
h() { history | tail -"$@"; }
lsl() { ls -lOe; }  # -O is a Mac-specific option
lsd() { ls -d */ .*/; }
lsb() { find "$@"; }  # bare directory listing (like DOS: `dir /b`)
lsapts() { F='/etc/apt/sources.list'; D="${L}.d"; [[ -f ${F} ]] && lsb ${F}; [[ -d ${D} ]] && lsb ${D}; }
pushd_() { pushd "$@" > /dev/null; }
popd_() { popd "$@" > /dev/null; }

lk() { open -a ScreenSaverEngine; }
rc() { e ${DOTFILES}/jffuncs.sh; }
src() { . ${DOTFILES}/jffn.sh; }  # reload function only
srcx() { . ${DOTFILES}/jfenv.sh; src; }  # also reload environment variables
path() { echo $PATH | tr ':' '\n'; }
func() { typeset -F; }
err() { echo $?; }
rm@() { xattr -cr; }
colors() { bash ${DOTFILES}/bin/colortest.sh; }
minr() { ruby ${DOTFILES}/bin/minrails.rb; }
treef() { tree --dirsfirst "$@"; }
treef1() { treef -L 1 "$@"; }
treef2() { treef -L 2 "$@"; }
treef3() { treef -L 3 "$@"; }
treef4() { treef -L 4 "$@"; }
treed() { treef -d "$@"; }
treed1() { treed -L 1 "$@"; }
treed2() { treed -L 2 "$@"; }
treed3() { treed -L 3 "$@"; }
treed4() { treed -L 4 "$@"; }
treed() { treef -d "$@"; }
wh() { grealpath $(which "$@"); }
broken() { find -L . -type l -ls; }
jj() { "$@" | python -mjson.tool; }
jjs() { while read l; do jj $l; done < "$@"; }
ipy() { ipython "$@"; }
psg() { ps -ef | head -1 && ps -ef | grep "$@"; }
cdiff() { diff -u 0 "$@" | sed "s/^-/`echo -e \"\x1b\"`[41m-/;s/^+/`echo -e \"\x1b\"`[42m+/;s/^@/`echo -e \"\x1b\"`[34m@/;s/$/`echo -e \"\x1b\"`[0m/"; }  # Mac-only
gdiff() { git diff -U0 --no-index "$@"; }
mktags() { mkdir -p ./.tags; ctags -R -f ./.tags/tags "$@" .; }
makels() { make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort | uniq; }

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
cronp() { ls -ldF /etc/cron* /var/spool/cron/crontabs/* 2> /dev/null; }

## Node-relate functions
nr() { npm run "$@"; }
nt() { npm test "$@"; }

## Docker-related functions
d() { docker "$@"; }
dcomp() { docker-compose "$@"; }
dm() { docker-machine "$@"; }
dmds() {
  local readonly prefix='Available drivers: '
  dm help create | grep "${prefix}" | sed -ne "s/^.*${prefix}//p" | sed 's/,//g'
}
dp() { d -v && dm -v && dcomp -v; }
dms() { dm ls; }
dmsh() { dm ssh "$@"; }
dmi() { dm inspect "$@" | jq .; }
dmu() { eval "$(dm env "$@")"; }
dmc() { dm create -d vmwarefusion --vmwarefusion-boot2docker-url 'https://github.com/cloudnativeapps/boot2docker/releases/download/v1.6.0-vmw/boot2docker-1.6.0-vmw.iso' $1; }
#dmc() { dm create -d vmwarefusion $1; }

## Vagrant-related functions
v() { vagrant "$@"; }
vv() { v version; }
vp() { vv; vps; v global-status; v status "$@" 2> /dev/null; }
vb() { v box "$@"; }
vbo() { vb outdated "$@"; }
vbs() { vb list -i "$@"; }
vbu() { vb update "$@"; }
vps() { v plugin list "$@"; }
vpu() { vps && v plugin update "$@"; vv; }
vsh() { v ssh "$@"; }
# vu() { v up --provider=vmware_fusion && vsh "$@"; }
vu() { v up "$@"; }
vhelp() { v help "$@"; }
vsus() { v suspend "$@"; }
vsw() { vsus "$1" && vush "$2"; }
vd() { v destroy -f "$@"; }
vl() { v reload "$@"; }
vdu() { vd "$@" && vu "$@"; }
vush() { vu "$@" && vsh "$@"; }
vdush() { vd "$@" && vush "$@"; }
vrps() { v reload --provision "$@" && vsh "$@"; }  # faster than vdus?
cdvp() { cd "${HOME}/vagrant/processing"; vp; }
cdvd() { cd "${HOME}/vagrant/boot2docker"; vp; }
cdvw() { cd "${HOME}/vagrant/vmwtest/"; }
cdvb() { cd "${HOME}/vagrant/vbtest/"; }

## Git-related functions
gp() { git status; git --version; }
gdiff_() { b0=$1; b1=$2; shift 2; git diff --color --minimal "${b0}..${b1}" "$@"; }
gstat_() { b0=$1; b1=$2; shift 2; git diff --color --minimal --stat "${b0}..${b1}" "$@"; }
gdiffl_() { pushd_ "${HOME}/github/linkscape"; gdiff_ ${B0:-'crawl-sched-Jul-5-2013'} ${B1:-'sprint-Gordon'} "$@"; popd_; }
gstatl_() { pushd_ "${HOME}/github/linkscape"; gstat_ ${B0:-'crawl-sched-Jul-5-2013'} ${B1:-'sprint-Gordon'} "$@"; popd_; }

diffb() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'liblinkscape/batch.cc'; }
statb() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'liblinkscape/batch.cc'; }
diffc() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'processing/crawlv2loop.cc'; }
statc() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'processing/crawlv2loop.cc'; }
difft() { B0='jf_comp_c' B1='jf_comp_p' gdiffl_ 'processing/test/batch_unittest.cc'; }
statt() { B0='jf_comp_c' B1='jf_comp_p' gstatl_ 'processing/test/batch_unittest.cc'; }

statx() { gstatl_ "cluster"; gstatl_ "processing/cluster"; }
statl() { gstatl_ .; }
# grab file from a particular commit.  Usage: ggrab filepath commit
ggrab() { git co $2 -- $1; }
# gmm() { git merge master; }
# grm() { git rebase master; }
grl() { git reflog --format=format:"%C(yellow)%h %Cblue%aD%Creset %gd %Cgreen%aN%Creset %gs %s"; }
cdg() { pushd_ ${HOME}/github/$1; } #bgp ${HOME}/github/$1; }
cdot() { pushd_ ${DOTFILES}; }
cdj() { cdg jwfearn/$1; }
cda() { cdg apptentive/$1; }
cdb() { cda bizint; }
cdc() { cda chef; }
cdd() { cda dokidoki; }
cde() { cda ekg; }
cdw() { cdj whiteboard; }
cdm() { cda apptentive-mapreduce/clusters/interactions-report; }
cdq() { cdj qless; }
cdr() { cdj resume; }
# cdt() { cd "${HOME}/_out/bhtmp/repo/"; }

ngrokw() { ngrok http 3000 "$@"; }

sha_() { cdc; bx knife ssh "role:$1 AND environment:production" -x ec2-user -a ipaddress 'cd /opt/apptentive/current && git rev-parse HEAD'; popd_; }
shaa() { sha_ 'web'; }
shab() { sha_ 'web-be'; }

doki() {
  bundle exec rake templates
  npm run compile-tests
  bundle exec foreman start
}

## Bundler-related functions
bcp() { cat ~/.bundle/config 2> /dev/null; cat .bundle/config 2> /dev/null; }
bp() { bundle list; bcp; bundle config "$@"; }
brm() { rm -rf vendor/bundle binstubs "$@"; }
# bi() { bundle install --standalone --path=vendor/bundle --binstubs=binstubs --full-index --jobs 4 "$@"; }
bi() { bundle install --standalone --path=vendor/bundle --binstubs=binstubs "$@"; }
biu() { rm Gemfile.lock; bi "$@"; }
#bspec() { binstubs/rspec "$@"; } # why doesn't thins work for 'web' project?
bx() { bundle exec "$@"; }
bxprod() { MONGODB_URI='mongodb://mongo/apptentive_production' bx "$@"; }
bo() { bundle outdated | grep "  * " | sort > "${HOME}/_out/outdated.txt"; }
bu() { bundle update "$@"; bi; }
bv() { bx bundle viz -f doc/gem_graph -F svg "$@"; }
bco() { bundle console "$@"; }
brb() { bx irb "$@"; } # use when bco fails
bry() { bx pry "$@"; }

## Rake-related functions
rk() { bx rake -G "$@"; }
rkt() { rk -T "$@"; }
rkta() { rkt -A "$@"; }
rkprod() { bxprod rake -G "$@"; }
# bli() { rk app:moz:lint; }
# bpt() { rk app:moz:plovrd_test; }
# byd() { rk app:moz:doc_yard; }

spec_() { time bx rspec --color "$@"; }
spec() { bx hound "$@" && spec_ "$@"; }
bjsp() { bx ruby -e 'require "execjs"; ExecJS.runtime'; }

## Rails-related functions
ra() { bx rails "$@"; }
rac() { ra console "$@"; }
ras() { ra server "$@"; }

ggp() { cat vendor/bundle/bundler/setup.rb | grep bundler/gems/; }
bfc() { cdf && bi && rk freya:compile; }
midd() { RAILS_ENV='development' bx rake middleware; }
midt() { RAILS_ENV='test' bx rake middleware; }
midp() { RAILS_ENV='production' bx rake middleware; }
# bgp() { bundle config --delete path; bundle config --global path $1/vendor/bundle; }
## Bundler-related aliases for local gem overrides
bon2_() { bundle config local.$1 ${HOME}/github/$2; } # use when gem != project ($1 = gem name, $2 = project name)
bon_() { bundle config local.$1 ${HOME}/github/$1; } # use when gem == project
bon() { bon2_ $1 $1; bundle config; }
ona() { bon alpha_bits; }
ond() { bon mozdev; }
oni() { bon interpol; }
# onl() { bon2_ legion legion-gem; bundle config; }
onm() { bon mozoo; }
ons() { bon SSSO; }
onv() { bon2_ vanguard-client vanguard; bon2_ vanguard-endpoints vanguard; bundle config; }
boff_() { bundle config --delete local.$1; }
boff() { boff_ $1; bundle config; }
offa() { boff alpha_bits; }
offd() { boff mozdev; }
offi() { boff interpol; }
# offl() { boff legion; }
offm() { boff mozoo; }
offs() { boff SSSO; }
offv() { boff_ vanguard-endpoints; boff vanguard-client; }

## Rubocop-related functions
# cop() { bx rubocop -F -c "$HOME/.rubocop.yml" "$@"; }
# hound() { cop $(git diff --name-only); }

## rbenv-related functions
rb+() { rbenv install $1; }
rb-() { rbenv uninstall $1; }
rbis_() { ruby-build --definitions; }
rbis() { rbis_ | column; }
rbup_() { brew upgrade rbenv 2> /dev/null; brew upgrade ruby-build 2> /dev/null; rbenv -v; ruby-build --version; }
rbup() { rbis_ > rbis0.txt; rbup_; rbis_ > rbis1.txt; gdiff rbis0.txt rbis1.txt; }
rbs() { rbenv -v; ruby-build --version; rbenv versions; echo "CURRENT RUBY: $(ruby -v)"; }
rb0() { rbenv local system; rbs; }
rb2() { rbenv local 2.3.0; rbs; }
rb225() { rbenv local 2.2.5; rbs; }
rbe() { rbenv each "$@"; }
rgs() { rbe -v gem list; }
rgo() { rbe -v gem outdated; }
rgu() { rbe -v gem update "$@"; }
rgc() { rbe -v gem cleanup; }
rbig() { local cc=$CC; export CC=gcc; rbi $1; export CC=cc; } # if rbi doesn't work, try this
gi() {
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
py+() { pyenv install $1; }
py-() { pyenv uninstall $1; }
pyup() { pyis_ > pyis0.txt; brew upgrade pyenv; pyis_ > pyis1.txt; gdiff pyis0.txt pyis1.txt; }
py0() { pyenv local system; pys; }
py2() { pyenv local 2.7.11; pys; }
py344() { pyenv local 3.4.4; pys; }
py3() { pyenv local 3.5.1; pys; }
pya() { pyenv local anaconda3-2.3.0; pys; }

#pyl() { pyenv local linkscape; }
syspip() { PIP_REQUIRE_VIRTUALENV='' pip "$@"; }
pyx() { local cmd="$@"; local py="from subprocess import check_output as x; o = x('$cmd'); print(o)"; echo $py; python -c"$py"; }
pea() { pyenv activate "$@"; }
ped() { pyenv deactivate "$@"; }
pyv() { pyenv virtualenv "$@"; }

## MySQL-related functions
my() { /usr/local/mysql/bin/mysql; }
myd() { /usr/local/mysql/bin/mysql server start; }
myad() { /usr/local/mysql/bin/mysqladmin; }
myp() { /usr/local/mysql/bin/mysqladmin -u root -p status; }
myfix() { sudo ln -ssudo ln -s /usr/local/mysql/lib/libmysqlclient.18.dylib /usr/lib/libmysqlclient.18.dylib; }

## Redis-related functions
redd() { redis-server "$@"; }
red() { redis-cli "$@"; }

## MongoDB-related functions
mdbs() { mongo --eval show dbs; }
mprod() { mongo mongo.corp.apptentive.com:27017/apptentive_production "$@"; }
mdev() { mongo localhost:27017/apptentive_development "$@"; }
xmprod() { mongo --host mongo.corp.apptentive.com --port 27017 apptentive_production "$@"; }
rr() { bx railroady -vbamM | sed -E 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | dot -Tsvg > rr.svg; }

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
# alias rmpid='rm ${HOME}/github/freya/tmp/pids/vanguard_stub_app.pid'
# alias cdlb='cd ${HOME}/FOWLER/work/tech/external/lb/lbfork'

cecho() { tput setab $1 && echo -n $1 && tput setab 0; }
# setab = Set background color using ANSI escape
# setaf = Set foreground color using ANSI escape

findname()  { find . -type f \( -name '' -or -name "$@" \); }
findpy() { findname '*.py'; }
findrb() { findname '*.rb'; }
# TODO: refactor findcpp
findcpp() { find . -type f \( -name '' -or -name '*.h' -or -name '*.hpp' -or -name '*.hxx' -or -name '*.c' -or -name '*.cc' -or -name '*.cpp' -or -name '*.cxx' \); }

_grb() { grep -r --include "*.rb" "$@" .; }
# grb() { _grb --exclude-dir=vendor "$@"; }
# grbv() { _grb --include-dir=vendor "$@"; } # TODO
grb() { ag --stats --ruby "$@" .; } # honors .gitignore, et al
# grbv() { "$@"; } # TODO

xgrep_in_bash_profiles() {
  profiles=('/etc/profile' '/etc/bash.bashrc' "~/.bashrc" "~/.bash_profile" "~/.bash_login" "~/.profile")
  for profile in ${profiles[@]}; do
    echo "${profile}"
  done
}

grep_in_bash_profiles() {
  profiles="/etc/profile /etc/bash.bashrc ${HOME}/.bashrc ${HOME}/.bash_profile ${HOME}/.bash_login ${HOME}/.profile"
  grep -s ${1} ${profiles}
}

fn_code_str() {	echo $(type ${1}); }

xenvp_() {
  for k in "$@"; do
    local v=$(eval \${${k}})
    if [[ -z "${v}" ]]; then
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
    local s=$(env | sort | grep ^${k}=)
    if [[ -z "${s}" ]]; then
      echo -e "${DIM}${k}${RESET}"
    else
      echo -e "${BRIGHT}${s}${RESET}"
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
    local style=${DIM}
    [[ -f "${f}" ]] && style=${BRIGHT}
    echo -e "${style}${f}${RESET}"
  done
}

bashprofiles_() {
  echo /etc/profile /etc/bash.bashrc ~/.bashrc ~/.bash_profile ~/.bash_login ~/.profile ~/.bash_logout
}

zshprofiles_() {
  echo /etc/zshenv ~/.zshenv /etc/zprofile ~/.zprofile /etc/zshrc ~/.zshrc /etc/zlogin ~/.zlogin ~/.zlogout /etc/zlogout
}

bashp() {
  bash --version
  filesp_ $(bashprofiles_)
  envp_ BASH_ENV # UNSET BLANK SPACE X
}

zshp() {
  zsh --version
  filesp_ $(zshprofiles_)
}

## dotfiles

### Requirements
1. A pre-installed script interpreter: `cmd` on Windows; or `bash` on Unix-like systems (Mac, Linux, Cygwin, MinGW, etc.)
1. The `git` version control program which you may need to install youself.  See: http://git-scm.com/

### Installation
**bash** (Mac, Linux, Cygwin, MinGW, etc.):
```bash
bash -c"pushd ~ && git clone git@github.com:jwfearn/dotfiles && source dotfiles/install.sh && popd"
```
**cmd** (Windows):
```bat
cmd /c"pushd %HOMEPATH% && git clone git@github.com:jwfearn/dotfiles && call dotfiles/install.bat && popd"
```

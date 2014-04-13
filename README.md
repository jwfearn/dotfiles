## dotfiles

### System Requirements

 - `git` See: http://git-scm.com/

And one of:
 - `bash` (Mac, Linux, Cygwin, MinGW, etc.)
 - `cmd` (Windows)

### Installation
**bash** (Mac, Linux, Cygwin, MinGW, etc.):
```bash
bash -c"pushd ~ && git clone git@github.com:jwfearn/dotfiles && source dotfiles/install.sh && popd"
```
**cmd** (Windows):
```bat
cmd /c"pushd %HOMEPATH% && git clone git@github.com:jwfearn/dotfiles && call dotfiles/install.bat && popd"
```

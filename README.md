## dotfiles

### Requirements
- Either `cmd` on Windows; or `bash` on Unix-like systems (Mac, Linux,
MinGW, Cygwin, etc.)  Typically pre-installed.
- The `git` version control program.  You may need to install this youself.
See: http://git-scm.com/

### Installation

#### Mac, Linux, Cygwin, MinGW, etc.
Paste the following line into your shell and hit enter:

```
bash -c "pushd ~ && git clone https://github.com/jwfearn/dotfiles.git && source dotfiles/install.sh && popd"
```

#### Windows
Paste the following line into your shell and hit enter:

```
cmd /e:on /c "pushd %HOMEPATH% && git clone https://github.com/jwfearn/dotfiles.git && call dotfiles/install.bat && popd"
```

The installation code above works in any shell as long as `cmd` or `bash` is
callable from it.

### Usage
*COMING SOON*

### TODO
- move `install.bat`, `install.sh` to a separate module?
- add a *refresh* script?
- tests: cmd/cmd, bash/bash, PowerShell/cmd, bash/cmd, zsh/bash, others?

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

The installation code above should work in any shell as long as `cmd` or
`bash` is callable from it.  For example, you can use `zsh` on the Mac or
`PowerShell` on Windows.

### Usage
*COMING SOON*

### TODO
- rename `install.bat` to `install.cmd`?
- move `install.*` to a separate module?
- add a *refresh* script?
- tests: cmd/cmd, bash/bash, PowerShell/cmd, bash/cmd, zsh/bash, others?

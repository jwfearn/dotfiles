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
- move `install.*` to a separate module?
- add a *refresh* script?
- tests: cmd/cmd, bash/bash, PowerShell/cmd, bash/cmd, zsh/bash, others?


## Windows VM setup
- get .zip file (local or https://www.modern.ie/en-us/virtualization-tools)
- get .vmware file (local or unzip above)
- open .vmware file with VMware Fusion (username: IEUser, password: Passw0rd!)
- launch Powershell as Administrator
- enable scripts:
  PS C:\> Set-ExecutionPolicy RemoteSigned
- install Chocolatey:
  PS C:\> iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
- quit/relaunch Powershell as Administrator
  PS C:\> choco install git
- copy file ???


## DOTZ - A dotfile manager
- cross platform: Windows/Mac/Linux
- no dependencies: (requires only `cmd` on Windows or POSIX `sh` on Mac/Linux)
- uses embedded git if no system git is available ???
- state: `~/.dotz.d`  (dir name ok on Windows?)


    | COMMAND  | DESCRIPTION                                                      |
    |:--------:|:---------------------------------------------------------------- |
    | version  | Dotz version info (aliases: -v, --version, /v)                   |
    | help     | Usage details (aliases: -h, --help, /h, /?)                      |
    | list     | show known dotfile sets, in use highlighted (alias: ls)          |
    | add      | takes a directory or a git repo                                  |
    | use      | start using one of the sets                                      |
    | outdated | checks if any repo-based sets are outdated ???                   |
    | update   | git pull for outdated repo-based sets  ???, use if necessary     |

### How it works
`use` takes a *set*.  If set not recognized, emit error.  If set is already
in use, do nothing.  Otherwise compare set dotfiles with *raw dotfiles*.  If
they do not match a known set, then do a *set-relative backup* ???

### State
    ~
    └── .dotz/
        ├── backup_xxx/  ???
        └── sets/
            ├── bar/
            └── foo/
                ├── myrepoclone/
                │    ├── .bashrc
                │    ├── .vimrc
                │    └── ...
                └── backup_xxx/  ???

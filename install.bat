@echo off
setlocal

REM Create a timestamp (format: YYYYMMDDHHMMSS)
for /f "tokens=1-3 delims=/:." %%a in ("%TIME%") do (set T=%%a%%b%%c)
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set T=%%c%%a%%b%T: =0%)
echo T: %T%

set fs=$(git ls-tree --full-tree --name-only HEAD)

set DOT=%HOMEPATH%\dotfiles
set BAK=%DOT%_backup_%T%
set X=(README.md install.sh install.bat)

pushd %DOT%\..
echo DOT: %DOT%
echo BAK: %BAK%
echo X: %X%
popd
endlocal

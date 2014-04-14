@echo off
setlocal EnableExtensions EnableDelayedExpansion

set H=%HOMEPATH%
set DOTS=%H%\dotfiles
REM Create a (local) timestamp, format: YYYYMMDDHHMMSS.
call :timestamp T
set BAK=%DOTS%_backup_%T%
set EXCLUDES=".gitignore README.md install.bat install.sh"

pushd %DOTS%

REM Get top-level non-ignored file and directory basenames.
for /f %%f in ('git ls-tree --full-tree --name-only HEAD') do (
  REM If not excluded
  echo %EXCLUDES% | findstr "%%f" > nul & if errorlevel 1 (
    REM If found in home directory
    if exist "%H%\%%f" (
      echo "WOULD DO: move %H%\%%f %BAK%\%%f"
      REM TODO: If not a link, back it up
      rem call :islink "%H%\%%f" L
      rem echo "%L%"
    )
  )
)

popd
endlocal
goto:EOF



REM Subroutines

:timestamp
setlocal
for /f "tokens=1-3 delims=/:." %%a in ("%TIME%") do (set ret=%%a%%b%%c)
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set ret=%%c%%a%%b%ret: =0%)
endlocal & if "%~1" neq "" set "%~1=%ret%"
goto:EOF


:ln_s
setlocal
set opt=""
REM Add /D option if target is a directory
pushd %2 2> nul && set opt="/D" & popd
mklink %opt% %1 %2
endlocal
goto:EOF


:islink
setlocal
for %%i in ("%1") do set (attribs=%%~ai)
echo attribs: %attribs%
set ret="1"
endlocal & if "%~2" neq "" set "%~2=%ret%"
goto:EOF


:xislink
setlocal
for %i in ("%1") do set attribs=%~ai
if "%attribs:~-1%" == "l" (set L=1) else (set L=0)
endlocal & if "%~2" neq "" set "%~2=%T%"
goto:EOF


goto:EOF
      call :islink "%H%\%%f" L
      echo "%L%    %H%\%%f"
      if %L% neq "1" (
        echo "WOULD DO: mv $H/$f $B/$f"
      )


      if %L% == "1" (
        mkdir %BAK% 2> nul
        echo %%f
      )

    if exist %f0% (
      call :islink "%f0%" L
      echo %L%
    )

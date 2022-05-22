@echo off
rem install.cmd -- Install the vim configuration files into the user's profile

rem Mike Barker <mike@thebarkers.com>
rem April, 20th 2016
rem Copyright (c) 2016 by Mike Barker

rem Change log:
rem 2016.04.20
rem * First release.

rem Check if the current command prompt is running elevated
whoami /groups | find "12288" >NUL
if %errorlevel% NEQ 0 (
    echo You must run the install from an elevated command prompt.
    exit /B
)

rem Check if %HOME% is defined, set it to %USERPROFILE% if not
if "%HOME%"=="" (
    echo Setting the home directory
    SETX HOME %USERPROFILE%
    SET HOME=%USERPROFILE%
)

rem Link the vimrc file and vim directory from the current directory
rem to the users profile directory.
mklink %HOME%\.vimrc %~dp0home\.vimrc
mklink %HOME%\_vimrc %~dp0home\.vimrc
mklink /d %HOME%\.vim %~dp0home\.vim
mklink /d %HOME%\vimfiles %~dp0home\.vim

rem Git clone the Vundle plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git %HOME%\vimfiles\bundle\Vundle.vim

echo Use vim and Vundle to install plugins
echo vim +PluginInstall +qall

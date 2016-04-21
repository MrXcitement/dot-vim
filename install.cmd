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

rem Link the vimrc file and vim directory from the current directory 
rem to the users profile directory.
mklink %HOME%\_vimrc %~dp0vimrc
mklink /d %HOME%\vimfiles %~dp0vim

rem Git clone the Vundle plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git %HOME%\vimfiles\bundle\Vundle.vim

rem Use vim and Vundle to install plugins 
vim +PluginInstall +qall

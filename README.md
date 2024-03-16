# Personal Vim setup

## Archived on 3/16/2024
I have migrated this configuration into my chezmoi [dotfiles](https://github.com/mrxcitement/dotfiles) repository.

This is my personal vim configuration.

I am currently using Vundle to manage plugins, the Vundle project is located here:
http://github.com/gmarik/vundle

My .vimrc automaticly installs vundle if it is not allready installed. I am using code from here:
http://erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc

To use this configuration, do the following:

## Clone
Clone the dot-vim repo to a local directory.

```
git clone git://github.com/mrxcitement/dot-vim.git ~/git/dot-vim
```

## Install
If you allready have a vim configuration, make sure to back it up first.
Switch to the local repo directory and run the install.sh script.
The install script will create symlinks in your home directory and then fetch the associated submodules from git.

```
cd ~/git/dot-vim
./install.sh
```


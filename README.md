###A simple vimrc setup using pathogen and git.

To install the configuration files, do the following:

Clone the repo:

    git clone git://github.com/mrxcitement/vimrc.git ~/src/vimrc

Create symlinks:

    ln -s ~/src/vimrc/vim ~/.vim
    ln -s ~/src/vimrc/vimrc ~/.vimrc

Switch to the `~/.vim` directory, and fetch submodules:

    cd ~/.vim
    git submodule update --init

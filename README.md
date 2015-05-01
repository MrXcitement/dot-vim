###A simple vimrc setup

This is my personal vim configuration. I am using pathogen to manage plugins that are installed as submodules.

To install the configuration files, do the following:

##Clone
Clone the vimrc repo to a local directory.

    git clone git://github.com/mrxcitement/vimrc.git ~/git/vimrc

##Install 
Switch to the repo directory and run the install.sh script. 
The install script will create symlinks in your home directory and then fetch the associated submodules from git.

	cd ~/git/vimrc
	./install.sh


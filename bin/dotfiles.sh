#!/bin/bash

install_dotfiles(){

	# Install Pathogen
	mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && \
	curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

	# Install Syntastic
	cd $HOME/.vim/bundle && \
	git clone https://github.com/scrooloose/syntastic.git && \

	# Install Nerdtree
	git clone https://github.com/scrooloose/nerdtree.git && \

	# Install Tagbar
	git clone https://github.com/majutsushi/tagbar.git && \

	# Install Vim-airline
	git clone https://github.com/vim-airline/vim-airline.git && \

	# Install Vim-airline themes
	git clone https://github.com/vim-airline/vim-airline-themes.git && \

	# Install YCM
	git clone https://github.com/Valloric/YouCompleteMe.git && \
	cd YouCompleteMe && \
	git submodule update --init --recursive && \
	python2 install.py --clang-completer --system-libclang

	# Stow dotfiles
	cd $HOME/dotfiles/
	stow chromium
	stow i3
	stow vim
	stow x
	stow zsh
	cd
	
	# Set background image
	feh --bg-scale $HOME/wallpapers/Nature.png

	# Install ohmyzsh
	wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	sed 's|env zsh||' -i install.sh
	cat install.sh | bash
	rm -rf .zshrc install.sh
	mv .zshrc.pre-oh-my-zsh .zshrc

}

# Update Vim plugins
update_dotfiles(){

	# Update YCM submodules
	cd $HOME/.vim/bundle/YouCompleteMe/ &&
		git submodule update --init --recursive

	# Update Pathogen plugins
	for i in $HOME/.vim/bundle/*; do git -C $i pull; done
	
}

# Do not run this script as root
if [[ $EUID -eq 0 ]]; then
	echo "error: this script should not be run as root."
	exit 1
fi

# User must provide exactly one argument
if [[ $# -ne 1 ]]; then
	echo "error: expected exactly 1 argument got $#."
	exit 1
fi

# Update or install
case $1 in
	-i|--install)
		echo "Installing dotfiles..."
		install_dotfiles
		;;
	-u|--update)
		echo "Updating dotfiles..."
		update_dotfiles
		;;
	*)
		echo "ERROR: Unknown argument $key."
		exit 1
		;;
esac
#!/bin/bash

if [[ ! -e $HOME/.dotfiles ]]; then
	git clone https://github.com/nutztherookie/dotfiles.git $HOME/.dotfiles
	pushd $HOME/.dotfiles
	#git checkout -b nutz origin/nutz
	popd
fi

pushd $HOME

rm -rvf .bash .bashrc .bash_profile
rm -rvf .gitconfig
rm -rvf .tmux.conf
[[ -L .ssh ]] && rm -rvf .ssh
rm -rvf .vim .vimrc

ln -sv .dotfiles/bashrc .bash
ln -sv .bash/main.sh .bashrc
ln -sv .bashrc .bash_profile

ln -sv .dotfiles/gitconfig .gitconfig

ln -sv .dotfiles/tmux.conf .tmux.conf

[[ ! -e .lftp ]] && mkdir .lftp
ln -sv $HOME/.dotfiles/lftp/rc .lftp/rc
ln -sv $HOME/.dotfiles/lftp/bookmarks .lftp/bookmarks

if [[ -e .bin ]]; then
	mv -v .bin .bin.bak
	ln -sv .dotfiles/bin .bin
	mv -v .bin.bak/* .bin/
	rmdir .bin.bak/
else
	ln -sv .dotfiles/bin .bin
fi


if [[ -e .ssh ]]; then
	mv -v .ssh .ssh.bak
	ln -sv .dotfiles/ssh .ssh
	mv -v .ssh.bak/* .ssh/
	rm -rvf .ssh.bak/
else
	ln -sv .dotfiles/ssh .ssh
fi

ln -sv .dotfiles/vim .vim
ln -sv .vim/vimrc .vimrc

popd

echo
echo "All done. Happy hacking ;)"
echo

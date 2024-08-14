#!/bin/zsh

rm ~/.zshrc
rm ~/.bashrc
rm ~/.bash_profile
rm ~/.Xresources
rm ~/.xinitrc
rm ~/.gitconfig
rm ~/.bash_logout
rm -rf ~/.config/nvim
rm -rf ~/.config/awesome

ln .zshrc ~/.zshrc
ln .bashrc ~/.bashrc
ln .bash_profile ~/.bash_profile
ln .Xresources ~/.Xresources
ln .xinitrc ~/.xinitrc
ln .gitconfig ~/.gitconfig
ln .bash_logout ~/.bash_logout

cp -r .config/nvim ~/.config
cp -r .config/awesome ~/.config

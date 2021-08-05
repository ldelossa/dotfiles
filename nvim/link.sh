#!/bin/bash

dest="$HOME/.config/"
source=`pwd`

rm -rf $dest/nvim
ln -s $source $dest

rm -rf $HOME/.vimrc
ln -s ./init.vim ~/.vimrc


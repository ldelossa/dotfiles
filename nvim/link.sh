#!/bin/bash

dest="$HOME/.config/nvim/"
source=`pwd`/

for file in `ls $source`; do
    if [[ $file == "link.sh" ]]; then
        continue
    fi
    if [[ $file == "init.vim" ]]; then 
        ln -s ${source}${file} ~/.vimrc
    fi
    ln -s ${source}${file} ${dest}${file}
done

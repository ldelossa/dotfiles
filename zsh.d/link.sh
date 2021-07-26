#!/bin/bash

dest="$HOME/zsh.d/"
source=`pwd`/

for file in `ls $source`; do
    if [[ $file == "link.sh" ]]; then
        continue
    fi
    ln -s ${source}${file} ${dest}${file}
done

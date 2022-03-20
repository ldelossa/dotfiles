#!/bin/bash

# " alpha:          000000 None
# " black:          #1c1c1c 234
# " black_light:    #262626 235
# " grey:           #949494 246
# " grey_light:     #6c6c6c 242
# " grey_lightest:  #e4e4e4 254
# " blue:           #0087af 031
# " blue_accent:    #87afd7 110
# " red:            #af5f5f 131
# " red_light:      #ff0000 196
# " yellow:         #ffff5f 227
# " green:          #87af87 108
# " orange:         #9b885c
# " purple:         #988ACF
# " cyan:           #4DC5C6

pkill tail
rm -rf $SWAYSOCK.wob && mkfifo $SWAYSOCK.wob
tail -f $SWAYSOCK.wob | wob --anchor "top" \
                            --anchor "right" \
                            --width  300 \
                            --height 40 \
                            --offset 0 \
                            --border 0 \
                            --margin 10 \
                            --background-color '#262626FF' \
                            --bar-color '#0087afFF'

#!/bin/bash

# " alpha:            000000 None
# " black_light:      #464646 235
# " black-lighter:    #3a3a3a 237
# " white:            #bcbcbc 250
# " grey_light:       #6c6c6c 242
# " grey_lighter:     #808080 244
# " grey_contrast:    #a8a8a8 248
# " grey_lightest:    #e4e4e4 254
# " blue:             #005f87 024
# " blue_accent:      #87afd7 110
# " red:              #af5f5f 131
# " red_lighter:      #ff0000 196
# " yellow:           #ffff5f 227
# " green:            #87af87 108
# " orange:           #9b885c
# " purple:           #806CCF
# " cyan;             #268889

pkill tail
rm -rf $SWAYSOCK.wob && mkfifo $SWAYSOCK.wob
tail -f $SWAYSOCK.wob | wob --anchor "top" \
                            --anchor "right" \
                            --width  300 \
                            --height 40 \
                            --offset 0 \
                            --border 0 \
                            --margin 10 \
                            --background-color '#FFa8a8a8' \
                            --bar-color '#FF806CCF'

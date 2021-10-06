#!/bin/bash

# quit closes spotify but triggers
# the monitor to update which immediately
# remove the widget instead of waiting for
# the next monitor interval.

if pgrep spotify
then
    kill -SIGINT $(pgrep spotify)
fi

pkill -RTMIN+4 waybar

#!/bin/bash

# The first two arguments are the paths to the files to compare
LOCAL_FILE="$1"
REMOTE_FILE="$2"

# Copy the file name to the clipboard using wl-copy
echo -n "$REMOTE_FILE" | wl-copy

# Launch your diff tool, e.g., nvimdiff
nvim -d "$LOCAL_FILE" "$REMOTE_FILE"

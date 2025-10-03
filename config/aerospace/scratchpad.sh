#!/bin/bash

scratchpad_launch_cmd="open -n -a kitty.app --args -T scratchpad --instance-group scratchpad"
scratchpad_window=($(aerospace list-windows --all --json | jq -r '(.[] | select(."window-title" == "scratchpad") | [."app-name", ."window-id", ."window-title"]) | join(" ") // ""'))

# if no scratchpad exists, launch it.
if [[ ${#scratchpad_window[@]} != 3 ]]; then
	echo "No previous scratchpad, launching it in current workspace"
	$scratchpad_launch_cmd
	exit
fi

# is scratchpad our currently focused windows?
focused_window=($(aerospace list-windows --focused --json | jq -r '(.[] | select(."window-title" == "scratchpad") | [."app-name", ."window-id", ."window-title"]) | join(" ") // ""'))
if [[ ${#focused_window[@]} == 3 ]]; then
	echo "Scratchpad currently focused, moving to .scratchpad workspace"
	aerospace move-node-to-workspace --window-id ${scratchpad_window[1]} '.scratchpad'
	exit
fi

# scratchpad is not currently focused, so move it to our current space and focus it
focused_workspace=$(aerospace list-workspaces --focused)

if [[ -z "$focused_workspace" ]]; then
	echo "No focused workspace found, exiting"
	exit
fi

# don't do anything if we are in the scratchspace workspace
if [[ "$focused_workspace" == ".scratchpad" ]]; then
	echo "Currently in .scratchpad workspace, not moving scratchpad"
	return
fi

echo "Moving scratchpad to current workspace: $focused_workspace"
aerospace move-node-to-workspace --fail-if-noop --window-id ${scratchpad_window[1]} "$focused_workspace"
aerospace focus --window-id ${scratchpad_window[1]}
exit

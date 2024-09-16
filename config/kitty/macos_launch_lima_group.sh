#!/bin/bash

if ! open --env LIMA_VM=1 -n -a kitty.app --args --single-instance --instance-group lima; then
	open -n -a kitty.app --args --single-instance --instance-group lima
fi

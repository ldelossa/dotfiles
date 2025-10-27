#!/bin/bash

if [ -f "/usr/local/bin/aws_completer" ]; then
	AWS_COMPLETER="/usr/local/bin/aws_completer"
elif command -v aws_completer >/dev/null 2>&1; then
	AWS_COMPLETER="$(command -v aws_completer)"
else
	AWS_COMPLETER=""
fi
complete -C "$AWS_COMPLETER" aws

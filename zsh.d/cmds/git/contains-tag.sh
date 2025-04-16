#!/bin/bash

commit="${1}"
git tag --contains "${commit}"

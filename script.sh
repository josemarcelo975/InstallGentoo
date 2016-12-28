#!/bin/bash

DIST_MIRROR="http://mirror.bytemark.co.uk/gentoo/"
_LATEST_STAGE3=$(curl -s 
$DIST_MIRROR/releases/amd64/autobuilds/latest-stage3-amd64.txt | 
tail -1 | awk '{print $1}')
_STAGE3_URI="$DIST_MIRROR/releases/amd64/autobuilds/$_LATEST_STAGE3"
wget $_STAGE3_URI

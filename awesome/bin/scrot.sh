#!/bin/sh

set -e
mkdir -p ~/Screenshots
f="$HOME/Screenshots/shot-$(date +%s).png"
scrot -o -s "$f"
feh "$f"

#!/bin/sh

R=`find "$1" | grep -P 'png$' | sort -R | head -n1`
exec i3lock -i $R -t

#!/bin/bash

cd $(dirname "$0")

sep="  |  "

out=$(/home/mediocregopher/.config/awesome/bin/cricket \
        --limit 1 \
        --ping-hosts 8.8.8.8 \
        --net-interval "" \
        --disk-interval "" \
        --disk-io-interval "")

function outNum {
    echo "$out" | grep "$1" | grep -oP "$2=\"[0-9]+\"" | grep -oP '[0-9]+'
}

echo -n "ping:$(outNum "ping result" "tookMSAvg")ms"

echo -n "$sep"

memBarSize=10
memPer=$(outNum "mem stats" "memUsedPer")
memUsed=$(expr $memPer / $memBarSize)
memUnused=$(expr $memBarSize - $memUsed)
echo -n "mem:"
for i in $(seq $memUsed); do echo -n "█"; done
for i in $(seq $memUnused); do echo -n "░"; done
for i in $(seq $(expr $memBarSize - $memUsed - $memUnused)); do echo -n "░"; done

echo -n "$sep"

cpuBarSize=20
cpuIdle=$(outNum "cpu stats" "cpuIdle")
cpuSys=$(outNum "cpu stats" "cpuSystem")
cpuUser=$(outNum "cpu stats" "cpuUser")
cpuTot=$(expr $cpuIdle + $cpuSys + $cpuUser)
function cpuL {
    python -c "print(int($1 / $cpuTot * $cpuBarSize))"
}
cpuLIdle=$(cpuL $cpuIdle)
cpuLSys=$(cpuL $cpuSys)
cpuLUser=$(cpuL $cpuUser)
echo -n "cpu:"
for i in $(seq $cpuLUser); do echo -n "█"; done
for i in $(seq $cpuLSys); do echo -n "▓"; done
for i in $(seq $cpuLIdle); do echo -n "░"; done
for i in $(seq $(expr $cpuBarSize - $cpuLIdle - $cpuLSys - $cpuLUser)); do echo -n "░"; done

echo ""

#!/bin/sh

if [ $# -ne 2 ] ; then
    echo Incorrect number of args: $# >&2
    return 1
fi

if [ -d "$2" ] ; then
    echo Failed to create "$2". >&2
    return 2
fi

mkdir "$2"
for i in "$1"/* ; do
    firstlvl=$(basename "$i")
    for j in "$i"/* ; do  
        secondlvl=$(basename "$j")
        mkdir "$2/${secondlvl}/"
        mkdir "$2/${secondlvl}/${firstlvl}"
        cp -nr "$j"/* "$2/${secondlvl}/${firstlvl}" # -n and -r combined!
    done
done

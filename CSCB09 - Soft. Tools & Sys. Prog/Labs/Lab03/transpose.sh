#!/bin/sh

if [ $# -ne 2 ] ; then
    echo Incorrect number of args: $# >&2
    return 1
fi

if [ $(mkdir "$2"; echo $?) -ne 0 ] ; then
    echo Failed to create "$2". >&2
    return 2
fi

cp -R "$1" "$2"

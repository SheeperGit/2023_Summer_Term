#!/bin/sh

if [ $# -lt 2 ] ; then
  echo 'Need source and target directories.' >&2
  exit 1
fi

src=$1
tgt=$2

if ! mkdir "$tgt" ; then
  echo "Can't create $tgt directory" >&2
  exit 2
fi  

for i in "$src"/* ; do
  ib=$(basename "$i")
  for j in "$i"/* ; do
    jb=$(basename "$j")
    mkdir -p "$tgt/$jb"
    cp -r "$j" "$tgt/$jb/$ib"
  done
done

#!/bin/sh

i=1
for arg in "$@" ; do
	echo arg"$i"="${arg}"
	i=$(expr "$i" + 1)
done

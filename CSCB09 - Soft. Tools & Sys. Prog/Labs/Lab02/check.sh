#!/bin/sh

was_d=1
until [ $# = 0 ] ; do
	## echo Current Arg: $1
	if [ "$1" = -d ] ; then
		## echo "-d" caught!
		was_d=0
		shift
		continue
	elif [ ${was_d} = 1 -a -e "$1" ] ; then ## Check if file exists
		echo $1 exists
	elif [ ${was_d} = 1 -a ! -e "$1" ] ; then
		echo $1 does not exist
	elif [ ${was_d} = 0 -a -d "$1" ] ; then ## Check if dir exists
		echo $1 is a directory
	elif [ ${was_d} = 0 -a ! -d "$1" ] ; then
		echo $1 is not a directory
	fi
	was_d=1
	shift
done


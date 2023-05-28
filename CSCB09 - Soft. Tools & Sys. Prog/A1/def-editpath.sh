#!/bin/sh

until [ $# = 0 ] ; do
	case "$1" in
		-a)
			echo Appending to PATH!
			;;
		-p)
			echo Prepending to PATH!
			;;
		-d)
			echo Deleting PATH!
			;;
	esac
	shift

done

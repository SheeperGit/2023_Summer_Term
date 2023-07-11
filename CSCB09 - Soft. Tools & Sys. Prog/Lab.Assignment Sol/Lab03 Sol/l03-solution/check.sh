#!/bin/sh

cond=e
while [ $# -gt 0 ] ; do
  if [ "$1" = -d ] ; then
    cond=d
    shift
    continue
  elif [ "$cond" = e ] ; then
    posmsg='exists'
    negmsg='does not exist'
  else
    posmsg='is a directory'
    negmsg='is not a directory'
  fi
  if [ -$cond "$1" ] ; then
    echo "$1 $posmsg"
  else
    echo "$1 $negmsg"
  fi
  cond=e
  shift
done
# A for-loop over "$@" is also fine, probably simpler.

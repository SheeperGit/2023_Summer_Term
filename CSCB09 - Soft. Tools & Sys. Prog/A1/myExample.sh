#!/bin/sh

. ./def-editpath.sh
PATH=/bin:/usr/bin:/usr/local/bin
editpath -a -- -a
/usr/bin/printenv PATH

editpath -p -- -p
/usr/bin/printenv PATH

editpath -a -- -p
/usr/bin/printenv PATH

editpath -p -- -a
/usr/bin/printenv PATH


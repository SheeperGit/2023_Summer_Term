#!/bin/sh

. ./def-editpath.sh
editpath -a -c -m -z /stain /eat /moop/smoke
/usr/bin/printenv PATH

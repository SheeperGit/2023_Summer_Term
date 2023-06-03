#!/bin/sh

. ./def-editpath.sh
editpath -p 'Job$' '/M' x
/usr/bin/printenv PATH

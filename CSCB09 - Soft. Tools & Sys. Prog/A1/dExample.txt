#!/bin/sh

. ./def-editpath.sh
editpath -d . 'Job$' usr
/usr/bin/printenv PATH

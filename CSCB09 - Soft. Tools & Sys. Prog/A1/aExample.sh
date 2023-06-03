#!/bin/sh

. ./def-editpath.sh
PATH=/bin:/usr/bin:/usr/local/bin
editpath -a '/xxx   yyy' /opt/bin .
/usr/bin/printenv PATH

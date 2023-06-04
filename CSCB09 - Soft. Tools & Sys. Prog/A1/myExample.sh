#!/bin/sh

. ./def-editpath.sh
editpath -a /cumstain /eat /poop/smoke
/usr/bin/printenv PATH

editpath -p '/my    my ' /where/is/semen
/usr/bin/printenv PATH

editpath -a -- -d GOD/JESUS/LOVE
/usr/bin/printenv PATH

editpath -p "/peepee     "
/usr/bin/printenv PATH

editpath -d /where/is/semen /cumstain /eat /randombullshit

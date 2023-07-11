#!/bin/sh

case "$1" in
    1)
        sh check.sh /usr dir/subdir/ /usr/bin
        ;;
    2)
        sh check.sh /non/existent dir/not/subdir dir/subdirectory
        ;;
    3)
        sh check.sh /non/existent dir/subdir /usr/bin dir/file1 dir/check.sh dir/subdir/file1
        ;;
    4)
        sh check.sh /usr/bin 'dir/with spaces/' 'dir/with spaces/file name' dir/with\ spaces/file\ name/invalid
        ;;
    5)
        sh check.sh /non/existent dir/subdir -d /usr/bin -d dir/file1 -d dir/check.sh -d dir/subdir/file2
        ;;
    6)
        sh check.sh -d -d /non/existent dir/subdir -d -d -d -d -d /usr/bin -dir/file1 -d -d -d -d -d dir/check.sh
        ;;
    *)
        echo 'test-check.sh: invalid argument.'
        exit 2
esac

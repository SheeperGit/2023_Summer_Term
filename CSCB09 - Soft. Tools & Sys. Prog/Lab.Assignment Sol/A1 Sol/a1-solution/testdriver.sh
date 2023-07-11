#!/bin/sh

. ./def-editpath.sh

case "$1" in
  # No option

  0a)
    PATH=/usr/bin:/bin:/usr/games
    editpath /usr/bin > /dev/null
    /usr/bin/printenv PATH
    ;;
  0b)
    PATH=/usr/bin:/bin:/usr/games
    editpath /usr/bin > /dev/null
    echo $?
    ;;

  # Append
  
  1a)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -a /opt/local/bin > /dev/null
    /usr/bin/printenv PATH
    ;;
  1b)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -a /opt/local/bin /home/student/bin /usr/local/sbin > /dev/null
    /usr/bin/printenv PATH
    ;;
  1c)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -a > /dev/null
    /usr/bin/printenv PATH
    ;;
  1d)
    PATH=/bin:/usr/bin:/usr/local/games
    foo=wrong
    editpath -a '/opt/local/$foo' > /dev/null
    /usr/bin/printenv PATH
    ;;
  1e)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -a -- /opt/local/bin > /dev/null
    /usr/bin/printenv PATH
    ;;

  # Prepend

  2a)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -p /opt/local/bin > /dev/null
    /usr/bin/printenv PATH
    ;;
  2b)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -p /opt/local/bin /home/student/bin /usr/local/sbin > /dev/null
    /usr/bin/printenv PATH
    ;;
  2c)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -p > /dev/null
    /usr/bin/printenv PATH
    ;;
  2d)
    PATH=/bin:/usr/bin:/usr/local/games
    foo=wrong
    editpath -p '/opt/local/$foo' > /dev/null
    /usr/bin/printenv PATH
    ;;
  2e)
    PATH=/bin:/usr/bin:/usr/local/games
    editpath -p -- /opt/local/bin > /dev/null
    /usr/bin/printenv PATH
    ;;

  # Delete

  3a)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d /usr/local/games > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3b)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d /usr/local/games /home/student/bin /opt/bin > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3c)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3d)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d /home/student > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3e)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d -- /usr/local/games > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3f)
    PATH='/bin:/home/student/my   bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin'
    editpath -d /usr/local/games > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3g)
    PATH='/bin:/home/student/my   bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin'
    editpath -d '/home/student/my   bin' > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3h)
    foo=wrong
    PATH='/bin:$foo:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin'
    editpath -d '$foo' > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3i)
    PATH='/bin:foo$:foo:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin'
    editpath -d 'foo$' > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3j)
    PATH='/bin:x:/usr/bin:/usr/local/games:.:/opt/bin'
    editpath -d . > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  3k)
    PATH=/bin:/home/student/bin:/usr/bin:/usr/local/games:/usr/sbin:/opt/bin
    editpath -d /usr/local/games > /dev/null
    /usr/bin/printenv PATH
    ;;
  3l)
    PATH=/home/student/bin:/usr/local/games:/usr/games
    editpath -d /usr/local/games > /dev/null
    /usr/bin/printenv PATH | /usr/bin/sed -E 's/:+$//'
    ;;
  *)
    echo "There is no test case $1" >&2
    exit 1
    ;;
esac

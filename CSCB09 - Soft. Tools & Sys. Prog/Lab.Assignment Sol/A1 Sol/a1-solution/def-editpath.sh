#!/bin/sh

editpath()
{
  mode=
  while getopts apd flag; do
    mode=$flag
  done
  if [ -z "$mode" ]; then
    echo 'need -a or -p or -d' >&2
    return 1
  fi
  shift $((OPTIND - 1))
  for f in "$@"; do
    case $mode in
      a)
        PATH="$PATH:$f"
        ;;
      p)
        PATH="$f:$PATH"
        ;;
      d)
        PATH="$(/usr/bin/printenv PATH \
                | /usr/bin/tr : '\n' \
                | /usr/bin/grep -v -x -F -e "$f" \
                | /usr/bin/head -c -1 \
                | /usr/bin/tr '\n' : )"
        ;;
      *)
        return 10
    esac
  done
}

#!/bin/sh

editpath() {
    ## No args - Exit Code (1) ##
    if [ $# = 0 ] ; then
        echo No args given! >&2
        return 1
    fi

    action=""

    while getopts ":apd" opt; do
        case "$opt" in
            a)
                action="append"
                ;;
            p)
                action="prepend"
                ;;
            d)
                action="delete"
                ;;
            *) # Unknown Option - If last arg, then Exit Code (2)
                action="-$OPTARG"
                ;;
        esac
    done

    ## Shift according to the # of opts. ##
    shift $(($OPTIND - 1))

    ## Perform action on PATH ##
    case $action in
        "append")
            for path in "$@"; do
                PATH=${PATH}:${path}
            done
            ;;
        "prepend")
            for path in "$@"; do
                PATH=${path}:${PATH}
            done
            ;;
        "delete")
            for pattern in "$@"; do
                ## Use grep to search for the pattern in PATH ##
        # Forward PATH's contents    # Replace ':' w/ '\n'  # Del lines w/ EXACT MATCHES    # Place back ':'       # Look for ':' at the end of PATH and replace w/ ''      
                PATH=$(echo "$PATH" | /usr/bin/tr ':' '\n' | /usr/bin/grep -vxF "$pattern" | /usr/bin/tr '\n' ':' | /usr/bin/sed 's/:$//')
            done
            ;;
        *) # Unknown Action - Do nothing
            echo "Invalid action: $action" >&2
            ;;
    esac

    export PATH
}

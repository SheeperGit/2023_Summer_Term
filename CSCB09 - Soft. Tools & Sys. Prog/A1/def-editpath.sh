#!/bin/sh

editpath() {
    action=""
    paths=""

    while getopts ":apd" opt; do
        case $opt in
            a)
                action="append"
                ;;
            p)
                action="prepend"
                ;;
            d)
                action="delete"
                ;;
            \?) # Unknown Option - Exit Code (1)
                echo "Invalid option: -$OPTARG" >&2
                return 1
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
                PATH=$(echo "$PATH" | grep -v "$pattern")
            done
            ;;
        *) # Unknown Action - Exit Code (2)
            echo "Invalid action: $action" >&2
            return 2
            ;;
    esac

    export PATH
}

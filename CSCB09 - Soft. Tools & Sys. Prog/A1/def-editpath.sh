#!/bin/sh

editpath() {
    action=""
    paths=""
    delimiter=":"

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
            \?) ## Unknown Option - Exit Code (1) ##
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done

    ## Shift according to the # of opts. ##
    shift $(($OPTIND - 1))

    # '--' Check #
    separator_index=-1
    for i in $(seq 1 $#); do
        if [ "${!i}" = "--" ]; then
            separator_index=$i
            break
        fi
    done

    # Separate opts and paths #
    if [ $separator_index -ne -1 ]; then
        paths="${@:$((separator_index + 1))}"
    else
        paths="$@"
    fi

    # Perform action on PATH #
    case $action in
        "append")
            for path in "${paths}"; do
                PATH="${PATH}${delimiter}"${path}""
            done
            ;;
        "prepend")
            for path in $paths; do
                PATH=""${path}"${delimiter}${PATH}"
            done
            ;;
        "delete")
            for path in $paths; do
                PATH=$(echo "$PATH" | awk -v RS="$delimiter" -v ORS="$delimiter" '!/'"$path"'/')
            done
            ;;
        *) ## Unknown Action - Exit Code (2) ##
            echo "Invalid action: $action" >&2
            return 2
            ;;
    esac

    export PATH
}


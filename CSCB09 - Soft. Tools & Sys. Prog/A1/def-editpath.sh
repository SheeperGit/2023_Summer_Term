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
            \?) # Unknown Option - Exit Code (1)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done

    ## Shift according to the # of opts. ##
    shift $(($OPTIND - 1))

    ## '--' Check ##
    separator_index=-1
    i=1
    for arg in "$@"; do
        if [ "$arg" = "--" ]; then
            separator_index=$i
            break
        fi
        i=$((i + 1))
    done

    ## Separate opts and paths ##
    if [ $separator_index -ne -1 ]; then
        paths="${@:$((separator_index + 1))}"
    else
        paths="$@"
    fi

    ## Perform action on PATH ##
    case $action in
        "append")
            for path in "$paths"; do
                find=" /"
                replace=":/"
                PATH="${PATH}${delimiter}${path}"
            done
            ;;
        "prepend")
            for path in "$paths"; do
                PATH="${path}${delimiter}${PATH}"
            done
            ;;
        "delete")
            for path in "$paths"; do
                PATH=$(echo "$PATH" | tr $delimiter '\n' | grep -vFx "$path" | tr '\n' $delimiter)
            done
            ;;
        *) # Unknown Action - Exit Code (2)
            echo "Invalid action: $action" >&2
            return 2
            ;;
    esac

    export PATH
}

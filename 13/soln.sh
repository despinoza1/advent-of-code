#!/bin/bash

set -euo pipefail


function get_column() {
    local line=()
    local curr="$1"
    shift
    local col="$1"
    shift
    local lines=()

    while (( "$#" != 0 )); do
        lines=("${lines[@]}" "$1")
        shift
    done

    for ((j = 0; j < curr; j++)); do
        char="${lines[$j]:$col:1}"
        line=("${line[@]}" "${char}")
    done

    echo "${line[@]/ //}"
}

function match_lines() {
    local matches=(0 0 0 0 0 0 0 0 0 0)
    local idx="$1"
    shift
    local len="$1"
    shift

    local pat=()
    local match=0

    while (( "$#" != 0 )); do
        pat=("${pat[@]}" "$1")
        shift
    done

    for ((j = 1; j < idx; j++)); do
        local k=0
        local flag=true

        while
        local line1=$(( j - k - 1 ))
        local line2=$(( j + k ))

        line1="${pat[$line1]}"
        line2="${pat[$line2]}"
        if [[ "$line1" != "$line2" ]]; then
            flag=false
            break
        fi

        k=$(( k + 1 ))
        (( j-k-1 >= 0 && j + k < idx )) || break
        do true; done

        if [ "$flag" = true ]; then
            matches[match]=$(( 100 * j))
            match=$(( match + 1 ))
        fi
    done

    for ((j = 1; j < len; j++)); do
        local k=0
        local flag=true

        while
        line1=$(get_column idx $(( j-k-1 )) "${pat[@]}")
        line2=$(get_column idx $(( j+k )) "${pat[@]}")
        if [[ "$line1" != "$line2" ]]; then
            flag=false
            break
        fi

        k=$(( k + 1 ))
        (( j-k-1 >= 0 && j+k < len )) || break
        do true; done

        if [ "$flag" = true ]; then
            matches[match]="$j"
            match=$(( match + 1 ))
        fi
    done

    if [ "$match" != 1 ]; then
        exit 1
    fi

    echo "${matches[0]}"
}

pattern=()
index=0
solution=0

while IFS= read -r line || [ -n "$line" ]; do
    printf '%s\n' "$line"

    if [ ${#line} = 0 ]; then
        line_len="${#pattern[0]}"

        val=( $(match_lines "$index" "$line_len" "${pattern[@]}") )

        solution=$(( solution + val ))
        index=0
        pattern=()
    else
        pattern=("${pattern[@]}" "$line")
        index=$(( index + 1 ))
    fi
done < "input.txt"

printf 'Solution: %d' $solution

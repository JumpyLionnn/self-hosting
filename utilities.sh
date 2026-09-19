#!/usr/bin/bash

read_key() {
    local -n rkey="$1"
    read -rsn1 rkey  # Read first byte (escape)
    if [[ "$rkey" == $'\e' ]]; then
        local escape_seq=""
        read -rsn2 -t 0.04 escape_seq # Read next 2 bytes (e.g., [A)
        rkey+=$escape_seq
    fi
}


# Clears n lines after the cursor inclusive
clear_lines() {
    local n=$1
    for i in $(seq $n)
    do
        echo -en "\e[2K\e[1B" # clear the current line and go the next one
    done
    echo -en "\e[2K\e[${n}A" # clear the current line and go back to the top
}

selection_menu() {
    local -r prompt="$1" outvar="$2" options=("${@:3}")
    local cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            (( ++index ))
        done
        #read -s -n3 key # wait for user to key in arrows or ENTER
        read_key key
        if [[ $key == "$esc[A" || $key == "k" ]] then # up arrow
            (( cur-- )); 
            (( cur < 0 )) && (( cur = 0 ))
        elif [[ $key == "$esc[B" || "$key" == "j" ]] then # down arrow
            (( ++cur )); 
            (( cur >= count )) && (( cur = count - 1 ))
        elif [[ $key == "" ]] then # nothing, i.e the read delimiter - ENTER
            break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done

    echo -en "\e[${count}A" # go up to the beginning to clear
    clear_lines $(($count + 1))

    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

yes_no() {
    echo -n "$1 "
    local res=""
    read -r res
    local res=$(tr "[:upper:]" "[:lower:]" <<< $res)
    if [[ $res != "yes" && $res != "y" && $res != "true" && $res != "go on" && $res != "continue" && $res != "sure" && $res != "confirm" ]]; then
        return 1 
    else
        return 0
    fi
}

mk() {
    path="$1"
    if [[ "$path" == *"/" ]]; then
        mkdir -p "$path"
    else
        mkdir -p $(dirname "$path")
        touch "$path"
    fi
}

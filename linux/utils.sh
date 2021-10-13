#!/bin/bash
# carrying utilities for scripts like error reporting
# as well as convenient variable

red='\33[38;5;0196m'
cyan='\033[38;5;087m' #for marking the being of a new sections
yellow='\033[38;5;226m' #for error
green='\033[38;5;154m' #for general messages
reset='\033[0m' #for resetting the color

quiet_stdout=">> /dev/null"
quiet_both=">> /dev/null 2>&1" # direct both stdout and stderr to null
#------------------------------------------------------------------------------

# print general messages
print_message()
{
    printf "${green}\n${1}${reset}"
    return 0
}

# error messaging
print_error()
{
    >&2 printf "${red}\n${1}${reset}" # direct to error output
    return 0
}

# got from https://unix.stackexchange.com/questions/267729/how-can-i-print-a-variable-with-padded-center-alignment
print_section() {
    termwidth="$(tput cols)"
    printf "${cyan}"
    padding="$(printf '%0.2s' --{1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
    printf "${reset}"
}

# announce which section of scripts are we on
print_section_old()
{
    printf "${cyan}\n${1}"
    printf "\n---------------------------------\n${reset}"
    return 0
}

# will log the time and error type
# log file format is date followed by, code section, followed by defailted description
# for log highlighting: https://marketplace.visualstudio.com/items?itemName=emilast.LogFileHighlighter
# $1 is type of log, $2 is which section of code, $3 is what happens
# type of log for this project should usually just be error
# for now only log error
log()
{
    touch ./maintainance.log
    printf '%-20s %-7s %-15s %-s\n' "$(date --iso-8601=date) $(date +'%H:%M:%S')" "${1}" "\"[${2}]\"" "${3}" >> ./maintainance.log
    return 0
}

# discard everything in stdin so far, works with multi line garbage
empty_input_buffer()
{
    read -d '' -t 0.1 -n 100000 unused || true # make sure this doesn't raise errors
    return 0
}

# check if the user is executing the script from inside the git repo
# first argument is the directory from home they need to be in, no / at beginning of arg
check_dir() 
{
    if [ ${PWD} != "${HOME}/${1}" ]; then
    print_error "You are not in the Debian setup directory, please go there and relaunch script"
    exit 1
    fi
    return 0
}

# print the given list in a table with given width
# 1st input is list, 2nd is table width, the reserved 
# length for each table member is hardcoded to be 30, change
# to make bigger/smaller
print_table()
{
counter=0
printf "${cyan}\nList:\n${reset}"
printf "${green}"
for software in ${1}; do 
printf "%-30s|  " "${software}"
counter=$((++counter))
if !((${counter}%${2})); then
printf "\n"
fi
done
printf "${reset}\n"
}
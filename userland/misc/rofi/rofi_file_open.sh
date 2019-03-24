#!/usr/bin/env bash
# source: https://github.com/carnager/rofi-scripts/blob/master/rofi-finder/finder.sh

# modify to use fd and has home directory option
# USE: rofi -show find -modi find:~/.local/share/rofi/finder.sh

if [ ! -z "$@" ]
then
  QUERY=$@
  if [[ "$@" == /* ]]
  then
    # input is path
    if [[ "$@" == *\?\? ]]
    then
      coproc ( xdg-open "${QUERY%\/* \?\?}"  > /dev/null 2>&1 )
      exec 1>&-
      exit;
    else
      coproc ( xdg-open "$@"  > /dev/null 2>&1 )
      exec 1>&-
      exit;
    fi
  elif [[ "$@" == \!\!* ]]
  then
    # input is help option
    echo "!!-- Type your search query to find files"
    echo "!!-- To search in home directory ~<search_query>"
    echo "!!-- To search again type !<search_query>"
    echo "!!-- To search parent directories type ?<search_query>"
    echo "!!-- You can print this help by typing !!"

  elif [[ "$@" == \?* ]]
  then
    while read -r line; do
      echo "$line"
    done <<< $(fd .*"${QUERY#\?}".* ~ 2>&1 | grep -v 'Permission denied\|Input/output error')

  elif [[ "$@" == \~* ]]
  then
    while read -r line; do
      echo "$line"
    done <<< $(fd .*"${QUERY#\~}".* ~ 2>&1 | grep -v 'Permission denied\|Input/output error')
  else
    fd .*"${QUERY#!}".* ~ 2>&1 | grep -v 'Permission denied\|Input/output error'
  fi
else
    fd . ~ # show every file in home path for user to choose
fi
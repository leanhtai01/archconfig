#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# auto start program
run compton -b
run goldendict
run ibus-daemon -drx
run xscreensaver -no-splash
run /home/leanhtai01/.config/awesome/touchpad_toggle.sh

#!/usr/bin/env bash

set -e

n_shortcuts=0
parent_dir=$(cd $(dirname $0)/..; pwd)
SCHEMATOLIST="org.gnome.settings-daemon.plugins.media-keys"
SCHEMATOITEM="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
PATHTOCUSTOMKEY="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"

# function add a shortcut
function add_shortcut() {
    index=$1
    name=$2
    binding=$3
    command=$4
    
    gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}${index}/ name "$name"
    gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}${index}/ binding "$binding"
    gsettings set $SCHEMATOITEM:${PATHTOCUSTOMKEY}${index}/ command "$command"
}

# ADD SHORTCUTS HERE
add_shortcut $((n_shortcuts++)) "Emacs" "<Primary><Alt>e" "emacs"
# add_shortcut $((n_shortcuts++)) "Chromium" "<Primary><Alt>c" "chromium"
# add_shortcut $((n_shortcuts++)) "LibreOffice" "<Primary><Alt>w" "libreoffice"
# add_shortcut $((n_shortcuts++)) "GNOME Terminal - zsh" "<Primary><Alt>r" "gnome-terminal -e zsh"
add_shortcut $((n_shortcuts++)) "Nautilus" "<Super>e" "nautilus"
add_shortcut $((n_shortcuts++)) "KeePassXC" "<Primary><Alt>p" "keepassxc"
add_shortcut $((n_shortcuts++)) "GNOME Terminal" "<Primary><Alt>t" "gnome-terminal"
add_shortcut $((n_shortcuts++)) "Foliate" "<Primary><Alt>b" "foliate"
# add_shortcut $((n_shortcuts++)) "Google Chrome" "<Primary><Alt>c" "google-chrome-stable"
# add_shortcut $((n_shortcuts++)) "GVim" "<Primary><Alt>v" "gvim"
# add_shortcut $((n_shortcuts++)) "GIMP" "<Primary><Alt>g" "gimp"
# add_shortcut $((n_shortcuts++)) "Inkscape" "<Primary><Alt>i" "inkscape"
# add_shortcut $((n_shortcuts++)) "OBS Studio" "<Primary><Alt>o" "obs"
add_shortcut $((n_shortcuts++)) "Virt Manager" "<Primary><Alt>v" "virt-manager"
add_shortcut $((n_shortcuts++)) "GNOME Authenticator" "<Primary><Alt>a" "flatpak run com.belmoussaoui.Authenticator"
add_shortcut $((n_shortcuts++)) "Double Commander" "<Primary><Alt>k" "doublecmd"
# add_shortcut $((n_shortcuts++)) "HakuNeko" "<Primary><Alt>h" "flatpak run io.github.hakuneko.HakuNeko"
# add_shortcut $((n_shortcuts++)) "Lutris" "<Primary><Alt>l" "lutris"
# add_shortcut $((n_shortcuts++)) "Steam" "<Primary><Alt>s" "steam-native"
# add_shortcut $((n_shortcuts++)) "Krusader" "<Primary><Alt>k" "krusader"
# add_shortcut $((n_shortcuts++)) "Firefox Developer Edition" "<Primary><Alt>f" "firefox-developer-edition"
# add_shortcut $((n_shortcuts++)) "Konsole - fish" "<Primary><Alt>y" "konsole -e fish"

# add short cut for Firefox Developer Edition with HW Acceleration
mkdir -p /home/$(whoami)/bash_scripts
cp $parent_dir/tools/open_firefox_hw_acceleration.sh /home/$(whoami)/bash_scripts
add_shortcut $((n_shortcuts++)) "Firefox Developer Edition" "<Primary><Alt>f" "/home/$(whoami)/bash_scripts/open_firefox_hw_acceleration.sh"

# add shortcut toggle touchpad
mkdir -p /home/$(whoami)/bash_scripts
cp $parent_dir/tools/toggle_touchpad_gnome.sh /home/$(whoami)/bash_scripts
add_shortcut $((n_shortcuts++)) "Toggle Touchpad" "<Super>t" "/home/$(whoami)/bash_scripts/toggle_touchpad_gnome.sh"

# re-define lockscreen shortcut
gsettings set $SCHEMATOLIST screensaver "['<Primary><Alt>l']"

# set custom-keybindings
((n_shortcuts--))

index=0
path_list="["
while [ $index -le $n_shortcuts ]; do
    # add a comma for all path other than 0
    if [ $index != 0 ]; then
	path_list+=", "
    fi
    
    path_list+="'${PATHTOCUSTOMKEY}${index}/'"
    index=$(( index + 1 ))
done
path_list+="]"

gsettings set $SCHEMATOLIST custom-keybindings "$path_list"

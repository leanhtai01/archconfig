#!/bin/bash

set -e

# display right margin
gsettings set org.gnome.gedit.preferences.editor display-right-margin true

# insert spaces
gsettings set org.gnome.gedit.preferences.editor insert-spaces true

# # set theme
# gsettings set org.gnome.gedit.preferences.editor scheme "'builder-dark'"

# enable plugins
gsettings set org.gnome.gedit.plugins active-plugins "['codecomment', 'colorpicker', 'wordcompletion', 'commander', 'bracketcompletion', 'smartspaces', 'spell', 'devhelp', 'sessionsaver', 'git', 'terminal', 'sort', 'filebrowser', 'modelines', 'docinfo', 'quickhighlight', 'multiedit', 'drawspaces', 'bookmarks', 'quickopen', 'findinfiles', 'externaltools']"

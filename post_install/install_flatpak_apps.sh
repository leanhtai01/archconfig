#!/bin/bash

set -e

sudo pacman -Syu --noconfirm
flatpak update
flatpak install com.belmoussaoui.Authenticator -y
flatpak install com.getferdi.Ferdi -y
flatpak install io.github.hakuneko.HakuNeko -y
# flatpak install com.albiononline.AlbionOnline -y
# flatpak install org.flightgear.FlightGear -y

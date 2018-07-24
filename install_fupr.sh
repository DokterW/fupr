#!/bin/bash
# fupr (install) v0.1
# Made by Dr. Waldijk
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
if [ ! -d $HOME/.dokter ]; then
    mkdir $HOME/.dokter
fi
if [ ! -d $HOME/.dokter/fupr ]; then
    mkdir $HOME/.dokter/fupr
fi
wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/fupr/master/start.sh -P $HOME/.dokter/fupr/
if [ ! -x $HOME/.dokter/fupr/start.sh ]; then
    chmod +x $HOME/.dokter/fupr/start.sh
fi
echo "alias fupr='$HOME/.dokter/fupr/start.sh'" >> $HOME/.bashrc
FUPRINST=$(pwd)
rm -f $FUPRINST/install_fupr.sh
# alias fupr='$HOME/.dokter/fupr/start.sh'

#!/bin/bash

BLUEIRIS_EXE="/root/wine/drive_c/Program Files/Blue Iris ${BLUEIRIS_VERSION}/BlueIris.exe"
PREFIX_DIR="/root/wine"
INSTALL_EXE="/root/blueiris.exe"

if [ ! -d "$PREFIX_DIR/drive_c" ]; then
    mv /root/wine_original/* /root/wine
fi

chown -R root:root /root/wine

if [ ! -e "$BLUEIRIS_EXE" ] ; then
    if [ ! -e "$INSTALL_EXE" ] ; then
        if [ "$BLUEIRIS_VERSION" == "4" ]; then
           wget -O "$INSTALL_EXE" https://blueirissoftware.com/BlueIris_48603.exe
        else
           wget -O "$INSTALL_EXE" http://blueirissoftware.com/blueiris.exe
        fi
    fi
    wine blueiris.exe
fi

wine "$BLUEIRIS_EXE"

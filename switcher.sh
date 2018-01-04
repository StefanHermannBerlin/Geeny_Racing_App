#!/bin/sh
USER=`whoami`
INIT_FILE="/home/${USER}/.xbindkeysrc"

if [ -e "$INIT_FILE" ]; then
    echo "Init File already created"
else
    echo "Init File not created. Creating..."
    xbindkeys --defaults > $INIT_FILE
    echo "$INIT_FILE created"
fi

xbindkeys &
/home/diegoeche/Geeny/Geeny_Racing_App/application.linux64/Geeny_Racing_App &
mplayer -fs -loop 0 /home/diegoeche/Geeny/Geeny_Racing_App/data/geenyAnimationK.mov &

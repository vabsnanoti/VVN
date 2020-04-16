#!/bin/bash

# 2/4/2020 - fix time zones
if [ -z "${TZ}" ]; then
        export TZ=America/Chicago
fi

# 2/4/2020 - added error checking for copy (usually perms)
#let's set a default directory
if [ -z "${DATADIR}" ]; then
        DATADIR="/opt"
fi

# if setenv is being overridden
if [ -f $DATADIR/startup/setenv.sh ] ; then
        cp $DATADIR/startup/setenv.sh /opt/setenv.sh || { echo "setenv copy failed"; exit 1; }
fi

# if Nasdaqcomm is being overridden
if [ -f $DATADIR/startup/Nasdaqcomm.sh ] ; then
        cp $DATADIR/startup/Nasdaqcomm.sh /opt/Nasdaqcomm.sh || { echo "Nasdaqcomm copy failed"; exit 1; }
fi


chmod 777 /opt/setenv.sh
exec /opt/setenv.sh run

#!/bin/bash

# 3/2/2016 - fix time zones
if [ -z "${TZ}" ]; then
        export TZ=America/Chicago
fi

cp /usr/share/zoneinfo/$TZ /config/timezone && echo $TZ > /etc/timezone
echo "export TZ=${TZ}"  >> /home/deployer/.bashrc


# 2/26/2019 - added error checking for copy (usually perms)
#let's set a default directory
if [ -z "${DATADIR}" ]; then
        DATADIR="/data/CoAc"
fi


# copy in db jar file
dbfile="false"
if [ -f $DATADIR/startup/ojdbc8.jar ]; then
        cp $DATADIR/startup/ojdbc8.jar /apache-tomcat/lib/ || { echo "ojdbc8 copy failed"; dbfile="false"; exit 1; }
        dbfile="true"
fi
if [ -f $DATADIR/startup/jconn3.jar ]; then
        cp $DATADIR/startup/jconn3.jar  /apache-tomcat/lib/ || { echo "jconn3 copy failed"; dbfile="false"; exit 1; }
        dbfile="true"
fi
if [ -f $DATADIR/startup/sqljdbc.jar ]; then
        cp $DATADIR/startup/sqljdbc.jar  /apache-tomcat/lib/ || { echo "sqljdbc copy failed"; dbfile="false"; exit 1; }
        dbfile="true"
fi
if [ -f $DATADIR/startup/db2jcc4.jar ]; then
        cp $DATADIR/startup/db2jcc4.jar  /apache-tomcat/lib/ || { echo "db2jdbc copy failed"; dbfile="false"; exit 1; }
        dbfile="true"
fi

if [ "$dbfile" == "false" ]; then
        echo "CRITICAL! NO DATABASE DRIVER FOUND! "
        exit 2
fi

# if setenv is being overridden
if [ -f $DATADIR/startup/setenv.sh ] ; then
        cp $DATADIR/startup/setenv.sh /apache-tomcat/bin/setenv.sh || { echo "setenv copy failed"; exit 1; }
fi

# if CoAcgenprop is being overriden
if [ -f $DATADIR/startup/CoAcgenprop.sh ] ; then
    cp $DATADIR/startup/CoAcgenprop.sh /apache-tomcat/CoAcgenprop.sh || { echo "CoAcgenprop copy failed"; exit 1; }
fi


# if server.xml is being overriden
if [ -f $DATADIR/startup/server.xml ] ; then
    cp $DATADIR/startup/server.xml /apache-tomcat/conf/server.xml || { echo "server copy failed"; exit 1; }
fi

# if context.xml is being overriden
if [ -f $DATADIR/startup/context.xml ] ; then
    cp $DATADIR/startup/context.xml /apache-tomcat/conf/context.xml || { echo "context copy failed"; exit 1; }
fi

# if web.xml is being overriden
if [ -f $DATADIR/startup/web.xml ] ; then
    cp $DATADIR/startup/web.xml /apache-tomcat/conf/web.xml || { echo "web copy failed"; exit 1; }
fi

# if catalina.properties is being overriden
if [ -f $DATADIR/startup/catalina.properties ] ; then
    cp $DATADIR/startup/catalina.properties /apache-tomcat/conf/catalina.properties || { echo "cata copy failed"; exit 1; }
fi

# set up logging directory
cd /apache-tomcat
host=`hostname -s`
rm -rf /apache-tomcat/logs
if [ ! -d $DATADIR/logs/$host ]; then
        mkdir $DATADIR/logs/$host || { echo "unable to make logs directory!"; exit 1; }
fi
ln -s $DATADIR/logs/$host /apache-tomcat/logs || { echo "unable to link logs directory"; exit 1; }

exec /apache-tomcat/bin/catalina.sh run



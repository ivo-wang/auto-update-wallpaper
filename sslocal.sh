#!/bin/sh
# chkconfig: 2345 90 10
# description: Start or stop the Shadowsocks client
#
### BEGIN INIT INFO
# Provides: Shadowsocks
# Required-Start: $network $syslog
# Required-Stop: $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Start or stop the Shadowsocks client
### END INIT INFO

conf=/etc/shadowsocks.json
#pid=/var/run/shadowsocks.pid
name='sslocal'

start(){
    /usr/local/bin/sslocal -c $conf -d start
    RETVAL=$?
    if [ "$RETVAL" = "0" ]; then
        echo "$name start success"
    else
        echo "$name start failed"
    fi
}

stop(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i '/usr/bin/python /usr/local/bin/sslocal ' | awk '{print $2}'`
    if [ ! -z $pid ]; then
        /usr/local/bin/sslocal -c $conf -d stop
        RETVAL=$?
        if [ "$RETVAL" = "0" ]; then
            echo "$name stop success"
        else
            echo "$name stop failed"
        fi
    else
        echo "$name is not running"
        RETVAL=1
    fi
}

status(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i '/usr/bin/python /usr/local/bin/sslocal' | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "$name is not running"
        RETVAL=1
    else
        echo "$name is running with PID $pid"
        RETVAL=0
    fi
}

case "$1" in
'start')
    start
    ;;
'stop')
    stop
    ;;
'status')
    status
    ;;
'restart')
    stop
    start
    RETVAL=$?
    ;;
*)
    echo "Usage: $0 { start | stop | restart | status }"
    RETVAL=1
    ;;
esac
exit $RETVAL

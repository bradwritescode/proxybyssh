#!/bin/sh
set -e

hostname="<ssh server>"
proxy_port="9050"

command="$1"
pid=`ps | grep ssh | grep $proxy_port | awk '{print $1}'`

if [ "$command" == "up" ] || [ "$command" == "start" ]; then
    if [ -n "$pid" ]; then
        echo "proxy is already up"
    else
        nohup ssh $hostname -D $proxy_port -N &>/dev/null &
        echo "proxy up - update proxy setting in System Preferences"
    fi
elif [ "$command" == "down" ] || [ "$command" == "stop" ]; then
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "proxy down - update proxy setting in System Preferences"
    else
        echo "proxy is already down"
    fi
elif [ "$command" == "bounce" ] || [ "$command" == "restart" ]; then
    proxy.sh down
    proxy.sh up
elif [ "$command" == "status" ]; then
    if [ -n "$pid" ]; then
        echo "proxy is up on pid ${pid}"
    else
        echo "proxy is down"
    fi
else
    echo "usage: proxy.sh [up|down|status]"
fi
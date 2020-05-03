#!/bin/bash

APP=snowrabbit-master
PROBE_SECRET=abc123

case $1 in
  build)
    echo "BUILD"
    docker build -t $APP .
    ;;

  start|run)
    echo "RUN"
    docker run --name $APP -d --rm -ePROBE_SECRET=$PROBE_SECRET -p 8090:4567 $APP
    ;;

  stop)
    echo "STOP"
    docker stop $APP
    ;;

  restart)
    echo "RESTART"
    $0 stop
    sleep 1
    $0 start
    ;;

  *)
    echo "Usage: $0 <build|start|stop|restart>"
    ;;
esac


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
    #### Removed --rm
    docker run --name $APP -d -ePROBE_SECRET=$PROBE_SECRET -p 8090:4567 $APP
    ;;

  stop)
    echo "STOP"
    docker stop $APP
    ;;

  restart)
    echo "RESTART"
    $0 stop
    sleep 1
    $0 rm
    sleep 1
    $0 start
    ;;

  rm)
    echo "RM"
    docker rm $APP
    ;;

  *)
    echo "Usage: $0 <build|start|stop|restart>"
    ;;
esac


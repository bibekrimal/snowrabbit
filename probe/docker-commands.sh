#!/bin/bash

APP=snowrabbit-probe
MASTER_HOST=172.17.0.3
MASTER_SECRET=abc123
PROBE_SITE=ewr

case $1 in
  build)
    echo "BUILD"
    docker build -t $APP .
    ;;

  start|run)
    echo "RUN"
    docker run --name $APP -d --rm -eMASTER_HOST=$MASTER_HOST -ePROBE_SITE=$PROBE_SITE -eMASTER_SECRET=$MASTER_SECRET $APP
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


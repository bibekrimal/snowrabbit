#!/bin/bash

case $1 in
  build)
    echo "BUILD"
    docker build -t snowrabbit-master .
    ;;

  run)
    echo "RUN"
    docker run --name snowrabbit-master -d --rm -p 8008:4567 snowrabbit-master
    ;;

  stop)
    echo "STOP"
    docker stop snowrabbit-master
    ;;

  restart)
    echo "RESTART"
    stop
    run
    ;;

  *)
    echo "Usage: $0 <build|run>"
    ;;
esac


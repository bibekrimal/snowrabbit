#!/bin/bash

case $1 in
  build)
    echo "BUILD"
    docker build -t askalice-node-master .
    ;;

  run)
    echo "RUN"
    docker run --name askalice-node-master -d --rm -p 8008:4567 askalice-node-master
    ;;

  stop)
    echo "STOP"
    docker stop askalice-node-master
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


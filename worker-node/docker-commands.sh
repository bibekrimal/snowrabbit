#!/bin/bash

case $1 in
  build)
    echo "BUILD"
    docker build -t snowrabbit-worker .
    ;;

  run)
    echo "RUN"
    docker run --name snowrabbit-worker -d --rm -p 8009:4567 snowrabbit-worker
    ;;

  stop)
    echo "STOP"
    docker stop snowrabbit-worker
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


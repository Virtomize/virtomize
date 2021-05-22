#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

UPDATEFILE="$DIR/tmp/UPDATE"

if [ -f "$UPDATEFILE" ] || [ "$1" == "-m" ]; then

  cd $DIR
  # just to be sure
  git checkout master

  # pull everything
  git pull
  docker-compose pull

  # restart
  docker-compose stop -t 20
  docker-compose rm -f
  docker-compose up -d

  rm -f $UPDATEFILE

fi

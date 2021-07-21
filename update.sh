#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

UPDATEFILE="$DIR/tmp/UPDATE"

while getopts mb: opt
do
   case $opt in
       m) m='true';;
       b) branch="${OPTARG}";;
       ?) echo "($0): unkown option"
   esac
done

if [ -f "$UPDATEFILE" ] || [ $m ]; then

  cd $DIR

  # pull git
  git pull

  if [ -z "$branch" ]; then
    echo "checkout master"
    git checkout master
  else
    echo "checkout $branch"
    git stash
    git checkout -f $branch
  fi

  # pull docker
  docker-compose pull

  # restart
  docker-compose stop -t 20
  docker-compose rm -f
  docker-compose up -d

  rm -f $UPDATEFILE

fi

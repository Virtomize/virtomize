#!/bin/bash

DIR=/opt/virtomize
UPDATEFILE="$DIR/tmp/UPDATE"
UPDATELOG="$DIR/update.log"
COMPOSE="/usr/local/bin/docker-compose"
ECHO="/usr/bin/echo $(date -u)"

while getopts mb: opt
do
   case $opt in
       m) m='true';;
       b) branch="${OPTARG}";;
       ?) echo "($0): unkown option"
   esac
done

if [ -f "$UPDATEFILE" ] || [ $m ]; then

  rm -vf $UPDATELOG

  $ECHO "$UPDATEFILE found start update"
  cd $DIR

  # pull git
  git pull

  if [ -z "$branch" ]; then
    $ECHO "checkout master"
    git checkout master
  else
    $ECHO "checkout $branch"
    git stash
    git checkout -f $branch
  fi

  $ECHO "exec $DIR/docker.sh"
  $DIR/docker.sh

  rm -vf $UPDATEFILE

fi

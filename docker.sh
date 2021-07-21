#!/bin/bash

DIR=/opt/virtomize
COMPOSE="/usr/local/bin/docker-compose"
ECHO="/usr/bin/echo $(date -u)"

$ECHO "cd $DIR"
cd $DIR

# pull docker
$ECHO "$COMPOSE pull"
$COMPOSE pull

# restart
$ECHO "$COMPOSE stop -t 20"
$COMPOSE stop -t 20
$ECHO "$COMPOSE rm -f"
$COMPOSE rm -f
$ECHO "$COMPOSE up -d"
$COMPOSE up -d

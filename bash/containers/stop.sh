#!/bin/bash

source ../config/config.sh

docker-compose -f "$SHARED_VOLUME/docker-compose.yml" stop


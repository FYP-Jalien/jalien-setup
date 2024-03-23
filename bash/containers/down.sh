#!/bin/bash

source "$1"

sudo docker-compose -f "$SHARED_VOLUME/docker-compose.yml" down


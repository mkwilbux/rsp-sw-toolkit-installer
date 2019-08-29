#!/bin/bash

set -u

cd dockerfiles/

run "(1/4) Building Docker Image RSP Avahi" \
	"docker build --rm ${DOCKER_BUILD_ARGS} -t  rsp/avahi:0.1 -f ./Dockerfile.avahi ." \
	${LOG_FILE}

run "(2/4) Building Docker Image RSP ntp" \
	"docker build --rm ${DOCKER_BUILD_ARGS} -t rsp/ntp:0.1 -f ./Dockerfile.ntp ." \
	${LOG_FILE}

run "(3/4) Building Docker Image RSP Mosquitto" \
	"docker build --rm ${DOCKER_BUILD_ARGS} -t rsp/mosquitto:0.1 -f ./Dockerfile.mosquitto ." \
	${LOG_FILE}
	
run "(4/4) Building Docker Image RSP Software Toolkit" \
	"docker build --rm ${DOCKER_BUILD_ARGS} -t rsp/sw-toolkit-gw:0.1 -f ./Dockerfile.rspgw ." \
	${LOG_FILE}

cd - > /dev/null

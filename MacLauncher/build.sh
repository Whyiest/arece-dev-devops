#!/bin/bash

# NON FONCTIONEL ! 

# Définition des paths pour Mac : 
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/Users/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="/tmp/.X11-unix:/tmp/.X11-unix\n      - $HOST_VOLUME_PATH:/home/arece/ros2_ws"

# TO DO : REMOVE THIS :
GPU="null"



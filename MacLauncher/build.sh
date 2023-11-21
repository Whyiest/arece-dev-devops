#!/bin/bash

# Définition des paths pour Mac : 
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/Users/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="/tmp/.X11-unix:/tmp/.X11-unix\n      - $HOST_VOLUME_PATH:/home/arece/ros2_ws"

# File integrity verification
file_check

# GPU detection
gpu_detect

# TO DO : REMOVE THIS :
GPU="null"
# TO DO : Définir les instructions GPU en fonction du GPU détecté
GPU_INSTRUCTIONS="devices:\n      - \"/dev/dri/card0:/dev/dri/card0\"\n      - \"/dev/dri/card1:/dev/dri/card1\"\n      - \"/dev/dri/renderD128:/dev/dri/renderD128\""

create_docker_compose

#!/bin/bash

# Définition des paths pour Windows (Change if needed)
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/c/Users/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="$HOST_VOLUME_PATH:/home/arece/ros2_ws"


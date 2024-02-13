#!/bin/bash

# Définition variables pour Linux :
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/home/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="$HOST_VOLUME_PATH:/home/arece/ros2_ws"

# Mise en place des permissions nécessaires :
echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Voulez-vous configurer les autorisations nécessaires sur Linux ? Cela nécesitera une élévation de privilège. Continuez ? (${NC}y/n${BLUE}) : ${NC}"
read ELEVATION_CHOICE
if [ "$ELEVATION_CHOICE" = "y" ]; then
    sudo chmod -R 777 /home/$USERNAME/ros2_ws
    sudo chmod -R 777 ./
fi
echo ""


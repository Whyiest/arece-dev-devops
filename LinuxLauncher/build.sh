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

# Vérification de l'existence des fichiers
file_check

# Détecter la présence d'une carte graphique NVIDIA, INTEL ou AMD
gpu_detect

# TO DO : Définir les instructions GPU en fonction du GPU détecté
#gpu_create_instructions
GPU_INSTRUCTIONS="null" # TEMPORAIRE : ANNULE LES EFFETS DE LA FONCTION PRECEDENTE

# Création du fichier docker-compose.yml :
create_docker_compose
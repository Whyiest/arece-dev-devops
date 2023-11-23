#!/bin/bash

# Définition des paths pour Windows (Change if needed)
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/c/Users/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="$HOST_VOLUME_PATH:/home/arece/ros2_ws"


# Vérification de l'existence du fichier docker-compose.yml
file_check

# GPU detection 
gpu_detect

# TO DO : Définir les instructions GPU en fonction du GPU détecté
gpu_create_instructions
#GPU_INSTRUCTIONS="null" # TEMPORAIRE : ANNULE LES EFFETS DE LA FONCTION PRECEDENTE


# Création du fichier docker-compose.yml :
create_docker_compose
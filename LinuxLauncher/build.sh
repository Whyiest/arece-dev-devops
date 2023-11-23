#!/bin/bash

# Définition variables pour Linux :
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/home/$USERNAME/ros2_ws"
VOLUME_INSTRUCTIONS="$HOST_VOLUME_PATH:/home/arece/ros2_ws"

# Mise en place des permissions nécessaires :
chmod -R 777 /home/$USERNAME/ros2_ws
chmod -R 777 ./

# Vérification de l'existence des fichiers
file_check

# Détecter la présence d'une carte graphique NVIDIA, INTEL ou AMD
gpu_detect

# TO DO : Définir les instructions GPU en fonction du GPU détecté
gpu_create_instructions
GPU_INSTRUCTIONS="null" # TEMPORAIRE : ANNULE LES EFFETS DE LA FONCTION PRECEDENTE

# Création du fichier docker-compose.yml :
create_docker_compose
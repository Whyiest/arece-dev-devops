#!/bin/bash

# Définition des paths pour Windows 
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/c/Users/$USERNAME/ros2_ws"


# Vérification de l'existence du fichier docker-compose.yml
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    handle_error "Erreur : le fichier $DOCKER_COMPOSE_FILE n'existe pas."
fi
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Docker Compose path :${NC} $DOCKER_COMPOSE_FILE"

# Vérification de l'existence du fichier Dockerfile
if [ ! -f "$DOCKER_FILE" ]; then
    handle_error "Erreur : le fichier $DOCKER_FILE n'existe pas."
fi
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Docker File path :${NC} $DOCKER_FILE"

# Vérification de l'existence du volume sur l'host
if [ ! -d "$HOST_VOLUME_PATH" ]; then
    handle_error "Erreur : le dossier $HOST_VOLUME_PATH doit être créé sur l'host pour poursuivre."
fi
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Host volume path :${NC} $HOST_VOLUME_PATH"


# GPU detection 
GPU="UNKNOWN"


# Création du fichier docker-compose.yml :
#   0 - Fichier python depuis build.sh
#   1 - Fichier template depuis build.sh
#   2 - Fichier de sortie depuis build.sh
#   3 - Nom d'utilisateur 
#   4 - GPU de l'utilisateur
python ../Utilities/FileBuilder.py "../Utilities/template.yml" "./$DOCKER_COMPOSE_FILE" "$USERNAME" "$GPU"

if [ $? -ne 0 ]; then
    handle_error "Erreur lors de la création du fichier docker-compose.yml."
fi

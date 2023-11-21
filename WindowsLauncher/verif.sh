#!/bin/bash

# Définition des paths pour Windows 
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/c/Users/$USER/ros2_ws"


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

# Remplacement du nom d'utilisateur dans le fichier docker-compose.yml
sed -i "s#/c/Users/$USER/ros2_ws#/home/$USER/ros2_ws#g" "$DOCKER_COMPOSE_FILE"
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Updated user: ${NC}$USER"

# GPU detection 
GPU="FICHIER DE PAUL"
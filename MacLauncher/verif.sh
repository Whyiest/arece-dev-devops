#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Pas de couleur

DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
# Adaptation du chemin pour macOS, utilisez le chemin approprié pour votre projet
HOST_VOLUME_PATH="/Users/$USER/ros2_ws"

# Vérification de l'existence du fichier docker-compose.yml
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le fichier $DOCKER_COMPOSE_FILE n'existe pas.${NC}"
    echo ""
    exit 1
fi

echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Docker Compose path :${NC} $DOCKER_COMPOSE_FILE"

# Vérification de l'existence du fichier Dockerfile
if [ ! -f "$DOCKER_FILE" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le fichier $DOCKER_FILE n'existe pas.${NC}"
    echo ""
    exit 1
fi
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Docker File path :${NC} $DOCKER_FILE"

# Vérification de l'existence du volume sur l'host
if [ ! -d "$HOST_VOLUME_PATH" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le dossier $HOST_VOLUME_PATH doit être créé sur l'host pour poursuivre.${NC}"
    echo ""
    exit 1
fi
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Host volume path :${NC} $HOST_VOLUME_PATH"

# Remplacement du nom d'utilisateur dans le fichier docker-compose.yml
sed -i "s#/Users/CHANGEHERE/ros2_ws#/home/arece/ros2_ws#g" "$DOCKER_COMPOSE_FILE"
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Updated user: ${NC}$USER"

# Pour macOS, la détection automatique de GPU peut ne pas être pertinente ou nécessaire
# Nous avons donc ajouter le chemin par défaut dans docker-compose.

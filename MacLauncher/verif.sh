#!/bin/bash

# Définition des paths pour Mac : 
DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
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

# Détection CPU : 
$GPU="FICHIER DE PAUL"

# Pour macOS, la configuration du GPU peut ne pas être nécessaire car tous les macs ont la même carte.
# Nous avons donc ajouter le chemin par défaut dans docker-compose.

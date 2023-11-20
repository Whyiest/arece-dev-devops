#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Pas de couleur

# Affichage de "ARECE" en art ASCII
echo -e "${BLUE} "
echo -e "    █████╗ ██████╗ ███████╗ ██████╗ ███████╗"
echo -e "   ██╔══██╗██╔══██╗██╔════╝██╔═══   ██╔════╝"
echo -e "   ███████║██████╔╝███████╗██║      ███████╗"
echo -e "   ██╔══██║██╔══██╗██║     ██║      ██║     "
echo -e "   ██║  ██║██║  ██║███████║╚██████╔╝███████║"
echo -e "   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝"
echo -e "${NC}"
echo ""


# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Affichage du nom d'utilisateur
echo -e "${BLUE} Utilisateur actuel : ${NC} $USERNAME"

# Demande à l'utilisateur de choisir entre Mac et Windows
echo -e "${BLUE} Choisissez votre système d'exploitation (mac/windows) : ${NC}"
read OS_CHOICE
LAUNCHER_PATH=""

if [ "$OS_CHOICE" = "mac" ]; then
    LAUNCHER_PATH="./MacLauncher"
elif [ "$OS_CHOICE" = "windows" ]; then
    LAUNCHER_PATH="./WindowsLauncher"
else
    echo -e "${RED} Choix invalide. Veuillez choisir 'mac' ou 'windows'.${NC}"
    exit 1
fi

DOCKER_COMPOSE_FILE="$LAUNCHER_PATH/docker-compose.yml"

# Vérification de l'existence du fichier docker-compose.yml
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo -e "${RED} Le fichier $DOCKER_COMPOSE_FILE n'existe pas.${NC}"
    exit 1
fi

# Remplacement du nom d'utilisateur dans le fichier docker-compose.yml
sed -i "s#/home/CHANGEHERE/ros2_ws#/home/$USERNAME/ros2_ws#g" "$DOCKER_COMPOSE_FILE"

echo -e "${GREEN} Le nom d'utilisateur a été mis à jour."
echo -e "${GREEN} Path :${NC} $DOCKER_COMPOSE_FILE."

# Lancement du container avec docker-compose
echo -e "${YELLOW} Lancement du container Docker... ${NC}"
cd "$LAUNCHER_PATH"
docker-compose up -d
echo -e "${GREEN} Container Docker lancé.${NC}"
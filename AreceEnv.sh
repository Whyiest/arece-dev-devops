#!/bin/bash

# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Default Path
MAC_FOLDER_PATH='./MacLauncher'
WINDOWS_FOLDER_PATH='./WindowsLauncher'
HOST_VOLUME_PATH="/home/$USERNAME/ros2_ws"

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

# Affichage du nom d'utilisateur
echo -e "${BLUE} Utilisateur actuel : ${NC} $USERNAME"

# Demande à l'utilisateur de choisir entre Mac et Windows
echo -e "${BLUE} Choisissez votre système d'exploitation (mac/windows) : ${NC}"
read OS_CHOICE

# Formation du path 

LAUNCHER_PATH=""

if [ "$OS_CHOICE" = "mac" ]; then
    LAUNCHER_PATH="$MAC_FOLDER_PATH"
elif [ "$OS_CHOICE" = "windows" ]; then
    LAUNCHER_PATH="$WINDOWS_FOLDER_PATH"

else
    echo -e "${NC}[${RED}⨯${NC} Erreur : choix invalide, votre os n'est pas pris en charge. Veuillez choisir 'mac' ou 'windows'. ${NC}"
    echo ""
    exit 1
fi

DOCKER_COMPOSE_FILE="$LAUNCHER_PATH/docker-compose.yml"
DOCKER_FILE="$LAUNCHER_PATH/Dockerfile"

# Remplacement du nom d'utilisateur dans le fichier docker-compose.yml
sed -i "s#/home/CHANGEHERE/ros2_ws#/home/$USERNAME/ros2_ws#g" "$DOCKER_COMPOSE_FILE"

# Information utilisateur - Début de test
echo ""
echo -e "${NC}[${GREEN}✔${NC}] Les chemins ont été mis à jour avec votre nom d'utilisateur : $USERNAME"
echo -e "${NC}[${GREEN}✔${NC}] Docker Compose : $DOCKER_COMPOSE_FILE"
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] Démarrage vérification..."
echo ""

# Vérification de l'existence du fichier docker-compose.yml
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le fichier $DOCKER_COMPOSE_FILE n'existe pas.${NC}"
    echo ""
    exit 1
fi

# Vérification de l'existence du fichier Dockerfile
if [ ! -f "$DOCKER_FILE" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le fichier $DOCKER_FILE n'existe pas.${NC}"
    echo ""
    exit 1
fi

# Vérification de l'existence du volume sur l'host
if [ ! -d "$HOST_VOLUME_PATH" ]; then
    echo -e "${NC}[${RED}⨯${NC}] Erreur : le dossier $HOST_VOLUME_PATH doit être créé sur l'host pour poursuivre.${NC}"
    echo ""
    exit 1
fi

# Information utilisateur - Fin de test
echo -e "${NC}[${GREEN}✔${NC}] Vérification terminée, prêt au lancement."
echo ""

# Lancement du container avec docker-compose
echo -e "${NC}[${BLUE}⧁${NC}] Lancement du container Docker... ${NC}"
cd "$LAUNCHER_PATH"
docker-compose up -d

# Fin programme
echo ""
echo -e "${NC}[${GREEN}✔${NC}] Container Docker lancé.${NC}"

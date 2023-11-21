#!/bin/bash

# Définition du temps d'affichage des informations :
SHOW_INFO_DELAY=5

# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Déclaration de la variable GPU
GPU="UNKNOWN"

# Default Path
ARM_FOLDER_PATH='./ARMLauncher'
x86_FOLDER_PATH='./x86Launcher'
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

# Information programme
echo -e "${GREEN}Si vous avez déjà lancé et créé une instance Docker avec cet outil, supprimez-la avec docker kill [instance] et effacez les fichiers liés."
echo ""

# Affichage du nom d'utilisateur
echo -e "${BLUE}Utilisateur actuel : ${NC} $USERNAME"

# Demande à l'utilisateur de son consentemment d'installation
echo -e "${BLUE}Voulez-vous lancer l'installation de l'environnement ARECE ? (${NC}y/n${BLUE}) : ${NC}"
read INSTALL_CHOICE

if [ "$INSTALL_CHOICE" = "y" ]; then
    echo ""
    elif [ "$INSTALL_CHOICE" = "n" ]; then
    echo -e "${NC}[${RED}⨯${NC}] ${RED}Annulation de l'installation.${NC}"
    exit 1
else
    echo -e "${NC}[${RED}⨯${NC}] ${RED}Choix non reconnu, annulation.${NC}"
    exit 1
fi


# Demande à l'utilisateur de choisir entre Mac et Windows
echo -e "${BLUE}Choisissez votre système d'exploitation (${NC}mac/windows/linux${BLUE}) : ${NC}"
read OS_CHOICE


# Information utilisateur - Début de test /////////////////////////////////
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${BLUE}Démarrage vérification..."
echo ""



# Définition des paths

LAUNCHER_PATH=""

#
if [ "$OS_CHOICE" = "mac" ]; then
    # ARM ONLY
    LAUNCHER_PATH="$ARM_FOLDER_PATH"
    elif [ "$OS_CHOICE" = "windows" ] || [ "$OS_CHOICE" = "linux" ]; then
    #X86 ONLY
    LAUNCHER_PATH="$x86_FOLDER_PATH"
    
else
    echo -e "${NC}[${RED}⨯${NC}] Erreur : choix invalide, votre os n'est pas pris en charge. Veuillez choisir 'mac' ou 'windows'. ${NC}"
    echo ""
    exit 1
fi

DOCKER_COMPOSE_FILE="$LAUNCHER_PATH/docker-compose.yml"
DOCKER_FILE="$LAUNCHER_PATH/Dockerfile"



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
sed -i "s#/home/CHANGEHERE/ros2_ws#/home/$USERNAME/ros2_ws#g" "$DOCKER_COMPOSE_FILE"

echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Updated user: ${NC}$USERNAME"




# Détecter la présence d'une carte graphique NVIDIA, INTEL ou AMD
echo -e "${NC}[${GREEN}?${NC}] ${GREEN}Souhaitez-vous auto-détecter la carte graphique ou la saisir manuellement ? (${NC}auto/manuel${GREEN}) : ${NC}"
read GPU_CHOICE


if [ "$GPU_CHOICE" = "auto" ]; then
    
    # Auto-détection du GPU
    if [ "$OS_CHOICE" = "linux" ]; then

        if [ "$(lspci | grep -i nvidia)" ]; then
            GPU="NVIDIA"
            elif [ "$(lspci | grep -i amd)" ]; then
            GPU="AMD"
            elif [ "$(lspci | grep -i intel)" ]; then
            GPU="INTEL"
        else
            GPU="UNKNOWN"
        fi

        elif [ "$OS_CHOICE" = "mac" ]; then
        if system_profiler SPDisplaysDataType | grep -i nvidia > /dev/null; then
            GPU="NVIDIA"
            elif system_profiler SPDisplaysDataType | grep -i amd > /dev/null; then
            GPU="AMD"
            elif system_profiler SPDisplaysDataType | grep -i intel > /dev/null; then
            GPU="INTEL"
        else
            GPU="UNKNOWN"
        fi

        elif [ "$OS_CHOICE" = "windows" ]; then
            echo -e "${NC}[${RED}⨯${NC}] Erreur : détection automatique impossible sous Windows. Merci d'essayer en manuel. ${NC}"
            exit 1
    fi
    elif [ "$GPU_CHOICE" = "manuel" ]; then
    
    
    # Saisie manuelle du GPU
    echo -e "${NC}[${GREEN}?${NC}] ${GREEN}Veuillez saisir le type de votre GPU (NVIDIA/AMD/INTEL) : ${NC}"
    read GPU_MANUAL
    GPU=$(echo "$GPU_MANUAL" | tr '[:lower:]' '[:upper:]') # Convertit en majuscules
else
    echo -e "${NC}[${RED}⨯${NC}] Erreur : choix invalide. Veuillez choisir 'auto' ou 'manuelle'. ${NC}"
    exit 1
fi

echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}GPU détecté/saisi: ${NC}${GPU}"


# Configuration selon le GPU

case "$GPU" in
    NVIDIA)
        # Modify the docker-compose file for NVIDIA GPU
        sed -i '/services:/a \ \ \ \ \ \ deploy:\n \ \ \ \ \ \ \ \ resources:\n \ \ \ \ \ \ \ \ \ \ reservations:\n \ \ \ \ \ \ \ \ \ \ \ \ devices:\n \ \ \ \ \ \ \ \ \ \ \ \ - driver: nvidia\n \ \ \ \ \ \ \ \ \ \ \ \ \ \ capabilities: [gpu]' "$DOCKER_COMPOSE_FILE"
        ;;
    AMD)
        # Configuration spécifique pour AMD
        ;;
    INTEL)
        # Configuration spécifique pour INTEL
        ;;
    *)
        echo -e "${NC}[${RED}⨯${NC}] ${RED}Erreur : Type de GPU non reconnu. L'application nécessite un GPU NVIDIA, AMD ou INTEL.${NC}"
        exit 1
        ;;
esac

echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Configuration GPU : ${NC}OK"




# Information utilisateur - FIN DE TEST /////////////////////////////////
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Vérification terminée."
echo ""
echo -e "${NC}[${YELLOW}⧁${NC}] ${GREEN}Prêt au lancement, début dans ${NC}$SHOW_INFO_DELAY second(s)."
echo ""
sleep $SHOW_INFO_DELAY



# Lancement du container avec docker-compose
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Construction du container Docker... ${NC}"
cd "$LAUNCHER_PATH"
docker-compose build || { echo -e "${NC}[${RED}⨯${NC}] Erreur lors de la construction du container Docker.${NC}"; exit 1; }

# Lancement du container avec docker-compose
echo ""
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Lancement du container Docker... ${NC}"
docker-compose up -d || { echo -e "${NC}[${RED}⨯${NC}] Erreur lors du démarrage du container Docker.${NC}"; exit 1; }

# Fin programme
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Container Docker lancé avec succès ! ${NC}"
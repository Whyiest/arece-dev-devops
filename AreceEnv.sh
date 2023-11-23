#!/bin/bash
export MSYS_NO_PATHCONV=1

# Définition du temps d'affichage des informations :
SHOW_INFO_DELAY=5

# Python launch command
PYTHON="python"

# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Déclaration de la variable GPU
GPU="UNKNOWN"

# Default Path
MAC_FOLDER='MacLauncher'
WINDOWS_FOLDER='WindowsLauncher'
LINUX_FOLDER='LinuxLauncher'
LAUNCHER_PATH=""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Pas de couleur

# Fonction de gestion des erreurs
handle_error() {
    echo -e "${NC}[${RED}⨯${NC}] ${RED}$1"
    echo -e "${NC}[${RED}⨯${NC}] ${RED}Press any key to exit the program...${NC}"
    read -r
    exit 1
}

gpu_detect() {
    echo ""
    echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Souhaitez-vous auto-détecter la carte graphique ou la saisir manuellement ? (${NC}auto/manuel${BLUE}) : ${NC}"
    read GPU_CHOICE
    
    if [ "$GPU_CHOICE" = "auto" ]; then
        # Auto-détection du GPU et attribution à la variable GPU
        GPU=$($PYTHON ../Utilities/AutoDetect.py)
    elif [ "$GPU_CHOICE" = "manuel" ]; then
        # Saisie manuelle du GPU
        echo ""
        echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Veuillez saisir le type de votre GPU (${NC}NVIDIA/AMD/INTEL${BLUE}) : ${NC}"
        read GPU_MANUAL
        GPU=$(echo "$GPU_MANUAL" | tr '[:lower:]' '[:upper:]') # Convertit en majuscules
    else
        handle_error "Erreur : choix invalide. Veuillez choisir 'auto' ou 'manuel'."
    fi
    
    # Vérification que l'entrée est l'une des options valides (NVIDIA, AMD, INTEL)
    if [ "$GPU" != "NVIDIA" ] && [ "$GPU" != "AMD" ] && [ "$GPU" != "INTEL" ] && [ "$GPU" != "APPLE" ]; then
        handle_error "Erreur : choix invalide. Veuillez choisir 'NVIDIA', 'AMD' ou 'INTEL' ou 'APPLE'."
    fi

    echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}GPU détecté/saisi: ${NC}${GPU}"
}

create_docker_compose () {
    #   0 - Fichier python depuis build.sh
    #   1 - Fichier template depuis build.sh
    #   2 - Fichier de sortie depuis build.sh
    #   3 - Nom d'utilisateur à insérer 
    #   4 - Instruction volume à insérer
    #   5 - GPU Instructions à insérer
    $PYTHON ../Utilities/FileBuilder.py "../Utilities/template.yml" "./$DOCKER_COMPOSE_FILE" "$USERNAME" "$VOLUME_INSTRUCTIONS" "$GPU_INSTRUCTIONS" 
    echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Utilisateur :${NC} $USERNAME"
    echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Instructions Volume :${NC} $VOLUME_INSTRUCTIONS"
    echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Instructions GPU :${NC} $GPU_INSTRUCTIONS"
    
    if [ $? -ne 0 ]; then
        handle_error "Erreur lors de la création du fichier docker-compose.yml."
    fi
}
 
file_check () {
    
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
    
    # Vérification de l'existance du volume sur l'host
    if [ ! -d "$HOST_VOLUME_PATH" ]; then
        handle_error "Erreur : le dossier $HOST_VOLUME_PATH doit être créé sur l'host pour poursuivre."
    fi
    echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Host volume path :${NC} $HOST_VOLUME_PATH"

}

gpu_create_instructions() {
    case $GPU in
        APPLE)
            GPU_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri\n    environment:\n      - LIBVA_DRIVER_NAME=iHD"
            ;;
        NVIDIA)
            # Instructions pour les GPU NVIDIA
            GPU_INSTRUCTIONS="deploy:\n      resources:\n        reservations:\n          devices:\n            - driver: nvidia\n              capabilities: [gpu]"
            ;;
        INTEL)
            # Instructions pour les GPU Intel
            GPU_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri\n    environment:\n      - LIBVA_DRIVER_NAME=iHD"
            ;;
        AMD)
            # Instructions pour les GPU AMD
            GPU_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri\n    environment:\n      - LIBVA_DRIVER_NAME=radeonsi"
            ;;
        UNKNOWN)
            # Gestion du cas où le GPU n'est pas reconnu
            handle_error "Erreur : Votre GPU n'est pas compatible. Si vous pensez que c'est une erreur, essayez d'indiquer manuellement votre GPU en relançant le script."
            ;;
        *)
            # Gestion de tout autre cas imprévu
            handle_error "Erreur : Type de GPU non reconnu."
            ;;
    esac
}


# Exportation 
export RED GREEN YELLOW BLUE NC
export GPU
export USERNAME
export LAUNCHER_PATH
export PYTHON
export -f handle_error
export -f gpu_detect
export -f create_docker_compose
export -f file_check
export -f gpu_create_instructions


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
echo -e "${NC}[${BLUE}🛈${NC}] ${BLUE}Utilisateur actuel : ${NC}$USERNAME"
echo -e "${NC}[${BLUE}🛈${NC}] ${BLUE}Dépendences : ${NC}python, docker-compose"

# Demande à l'utilisateur de son consentemment d'installation
echo ""
echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Voulez-vous lancer l'installation de l'environnement ARECE ? (${NC}y/n${BLUE}) : ${NC}"
read INSTALL_CHOICE

if [ "$INSTALL_CHOICE" = "y" ]; then
    echo ""
elif [ "$INSTALL_CHOICE" = "n" ]; then
    handle_error "Annulation de l'installation."

else
    handle_error "Choix non reconnu, annulation."
fi

# Demande à l'utilisateur de choisir entre Mac et Windows
echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Choisissez votre système d'exploitation (${NC}mac/windows/linux${BLUE}) : ${NC}"
read OS_CHOICE

if [ "$OS_CHOICE" = "mac" ]; then
    # ARM ONLY
    LAUNCHER_PATH="$MAC_FOLDER"
elif [ "$OS_CHOICE" = "windows" ]; then
    # x86 ONLY
    LAUNCHER_PATH="$WINDOWS_FOLDER"
elif [ "$OS_CHOICE" = "linux" ]; then
    # x86 ONLY
    LAUNCHER_PATH="$LINUX_FOLDER"
else
    handle_error "Erreur : choix invalide, votre os n'est pas pris en charge."
fi

# Demande à l'utilisateur quel préfixe Python utiliser
echo ""
echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Quel préfixe utilisez-vous sur votre ordinateur pour exécuter des scripts Python (${NC}python, py, python3${BLUE}) : ${NC}"
read PYTHON_PREFIX
PYTHON=$PYTHON_PREFIX
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Les scripts seront éxecutés avec $PYTHON. En cas de problème de création de fichier ou de détection de GPU, essayez de changer cette variable.${NC}"

# Information utilisateur - DEBUT CONFIGURATION
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${GREEN}Démarrage vérification..."
echo ""
cd "./$LAUNCHER_PATH"

# Vérification intégrité fichier build
if [ ! -f "build.sh" ]; then
    handle_error "Erreur : impossible de trouver le fichier de vérification de l'OS (./$LAUNCHER_PATH/build.sh)."
fi

./build.sh
BUILD_EXIT_CODE=$?  
if [ $BUILD_EXIT_CODE -ne 0 ]; then
    exit 1  # Arrête AreceEnv.sh si build.sh a échoué
fi

# Information utilisateur - FIN CONFIGURATION 
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Vérification terminée."
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Prêt au lancement, début dans ${NC}$SHOW_INFO_DELAY second(s)."
echo ""
sleep $SHOW_INFO_DELAY

# Lancement du container avec docker-compose
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Construction du container Docker... ${NC}"
docker-compose build || handle_error "Erreur lors de la construction du container Docker. Si vous utilisez Docker Desktop, assurez-vous qu'il soit lancé."

# Lancement du container avec docker-compose
echo ""
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Lancement du container Docker... ${NC}"
docker-compose up -d || handle_error "Erreur lors du lancement du container Docker. Si vous utilisez Docker Desktop, assurez-vous qu'il soit lancé. "

# Fin programme
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Container Docker lancé avec succès ! ${NC}"
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Press any key to exit the program...${NC}"
read -r
exit 1
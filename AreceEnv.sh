#!/bin/bash
export MSYS_NO_PATHCONV=1

# Mode debug - UNCOMMENT IF NEEDED
# Permet de stopper le script sur la première erreur
# set -e 
# trap 'echo -e "${RED}DEBUG : Erreur détectée. Appuyez sur une touche pour quitter.${NC}"; read -r' EXIT

# ----------------------------- VARIABLES ----------------------------#

# Définition du temps d'affichage des informations :
SHOW_INFO_DELAY=5

# Python launch command
PYTHON="python"

# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Déclaration de la variable GPU
GPU="UNKNOWN"

# Default Path
MAC_FOLDER='MacLauncher' # IMPORTANT : Non supporté
WINDOWS_FOLDER='WindowsLauncher'
LINUX_FOLDER='LinuxLauncher'
LAUNCHER_PATH=""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Pas de couleur

# ----------------------------- FONCTIONS ----------------------------#

# Fonction de gestion des erreurs
handle_error() {
    echo -e "${NC}[${RED}⨯${NC}] ${RED}$1"
    echo -e "${NC}[${RED}⨯${NC}] ${RED}Press any key to exit the program...${NC}"
    read -r
    exit 1
}

# Cette fonction permet de détecter automatiquement quel GPU est présent sur le système
gpu_detect() {    
    # Auto-détection du GPU et attribution à la variable GPU
    GPU=$($PYTHON ./Utilities/AutoDetect.py)
   
    
    # Vérification que l'entrée est l'une des options valides (NVIDIA, AMD, INTEL)
    if [ "$GPU" != "NVIDIA" ] && [ "$GPU" != "AMD" ] && [ "$GPU" != "INTEL" ] && [ "$GPU" != "APPLE" ]; then
        handle_error "Erreur : GPU non reconnu. Veuillez utiliser un GPU 'NVIDIA', 'AMD' ou 'INTEL' ou 'APPLE'."
    fi
}

# Cette fonction permet de créer le Docker Compose en fonction de l'OS et du GPU.
create_docker_compose () {
    #   0 - Fichier python depuis build.sh
    #   1 - Fichier template depuis build.sh
    #   2 - Fichier de sortie depuis build.sh
    #   3 - Nom d'utilisateur à insérer 
    #   4 - Instruction volume à insérer
    #   5 - GPU Instructions à insérer
    
    $PYTHON ./Utilities/FileBuilder.py "./Utilities/template.yml" "./$LAUNCHER_PATH/$DOCKER_COMPOSE_FILE" "$USERNAME" "$VOLUME_INSTRUCTIONS" "$DEVICE_INSTRUCTIONS" "$ENV_INSTRUCTIONS"
    
    
    if [ $? -ne 0 ]; then
        handle_error "Erreur lors de la création du fichier docker-compose.yml."
    fi
}
 
# Vérifie que tous les fichiers soient bien présents
file_check () {
    
    cd "./$LAUNCHER_PATH"
    
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
    
    cd "../"

}

# Permet de définir les instructions GPU
gpu_create_instructions() {
    case $GPU in
        APPLE)
            DEVICE_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri"
            ENV_INSTRUCTIONS="- LIBVA_DRIVER_NAME=iHD"
            ;;
        NVIDIA)
            DEVICE_INSTRUCTIONS="deploy:\n      resources:\n        reservations:\n          devices:\n            - driver: nvidia\n              capabilities: [gpu]"
            ENV_INSTRUCTIONS=""
            ;;
        INTEL)
            DEVICE_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri"
            ENV_INSTRUCTIONS="- LIBVA_DRIVER_NAME=iHD"
            ;;
        AMD)
            DEVICE_INSTRUCTIONS="devices:\n      - /dev/dri:/dev/dri"
            ENV_INSTRUCTIONS="- LIBVA_DRIVER_NAME=radeonsi"
            ;;
        UNKNOWN)
            handle_error "Erreur : Votre GPU n'est pas compatible. Si vous pensez que c'est une erreur, essayez d'indiquer manuellement votre GPU en relançant le script."
            ;;
        *)
            handle_error "Erreur : Type de GPU non reconnu."
            ;;
    esac
}


# Auto-détection du système d'exploitation
os_detect() {
    
    # Récupératio de la version système
    UNAME_OUT="$(uname -s)"
    
    # Selon le préfixe, determination de l'OS
    case "${UNAME_OUT}" in
        Linux*)     OS='Linux';;
        Darwin*)    OS='Mac';;
        CYGWIN*|MINGW*|MSYS*|MINGW*) OS='Windows';;
        *)          handle_error "Système d'exploitation non pris en charge.";;
    esac
}

# Détermine le path où se trouvent les fichiers
os_path() {
    
    # Détermination du path des fichiers
    case "$OS" in
        Mac) LAUNCHER_PATH='MacLauncher' ;;
        Linux) LAUNCHER_PATH='LinuxLauncher' ;;
        Windows) LAUNCHER_PATH='WindowsLauncher' ;;
        *) handle_error "Système d'exploitation non pris en charge.";;
    esac
}

# Permet d'éxecuter des lignes supplémenatires selon l'OS
os_build() {
    
    cd "./$LAUNCHER_PATH"
    
    # Vérification fichier
    if [ ! -f "build.sh" ]; then
      handle_error "Erreur : impossible de trouver le fichier de vérification de l'OS (./$LAUNCHER_PATH/build.sh)."
    fi
    
    # Exécution des commandes spécifiques    
    source build.sh
    
    # Vérification erreurs
    BUILD_EXIT_CODE=$? 
    if [ $BUILD_EXIT_CODE -ne 0 ]; then
        handle_error "Un problème est survenu lors de l'éxecution du fichier build.sh"
    fi
    
    cd "../"
}


# Permet de détecter quel préfixe python est utilisé selon l'OS.
python_detect() {
    
    # Détection du préfixe Python
    if [ "$OS" = "Windows" ]; then
        # Utilise where (Windows) pour la détection
        if where python > /dev/null 2>&1; then
            PYTHON="python"
        elif where python3 > /dev/null 2>&1; then
            PYTHON="python3"
        else
            handle_error "Python n'est pas installé ou n'est pas accessible dans le PATH. L'installation ne peut pas continuer."
            exit 1
        fi
    else
        # Utilise which (Unix/Linux) pour la détection
        if which python > /dev/null 2>&1; then
            PYTHON="python"
        elif which python3 > /dev/null 2>&1; then
            PYTHON="python3"
        else
            handle_error "Python n'est pas installé ou n'est pas accessible dans le PATH."
            exit 1
        fi
    fi
}

# Demande le consentemment de l'utilisateur pour lancer l'installation : 
installation_consent() {
    echo -ne "${NC}[${YELLOW}?${NC}] ${BLUE}Voulez-vous lancer l'installation de l'environnement ARECE ? (${NC}y/n${BLUE}) : ${NC}"
    read INSTALL_CHOICE

    if [ "$INSTALL_CHOICE" = "y" ]; then
        echo ""
    elif [ "$INSTALL_CHOICE" = "n" ]; then
        handle_error "Annulation de l'installation."
    else
        handle_error "Choix non reconnu, annulation."
    fi
}


# ----------------------------- EXPORT ----------------------------#


# Exportation 
export RED GREEN YELLOW BLUE NC
export GPU
export USERNAME
export LAUNCHER_PATH
export PYTHON
export -f handle_error



# ----------------------------- DETECTION ----------------------------#


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
echo -e "${GREEN}${NC}[${BLUE}🛈${NC}] ${GREEN}Si vous avez déjà lancé et créé une instance Docker avec cet outil, supprimez-la avec docker kill [instance] et effacez les fichiers liés."
echo ""
echo -e "${NC}[${BLUE}🛈${NC}] ${BLUE}Dépendences : ${NC}python, docker-compose"

# Demande à l'utilisateur de son consentemment d'installation
echo ""
installation_consent


# Lancement des détections automatiques : 
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${GREEN}[1] - Détections"
echo ""

echo -e "${NC}[${BLUE}✔${NC}] ${BLUE}Installation pour : ${NC}$USERNAME"

os_detect
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}OS detecté : ${NC}$OS.${NC}"

os_path
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Dossier d'installation : ${NC}$LAUNCHER_PATH.${NC}"

python_detect
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Les scripts seront éxecutés avec ${NC}$PYTHON.${NC}"

gpu_detect
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}GPU detecté :  ${NC}$GPU.${NC}"


# ----------------------------- PREPARATION ----------------------------#


# Information utilisateur 
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${GREEN}[2] - Préparation"
echo ""

# Lancement fichier build selon l'OS
os_build
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Fichier chargé :${NC} $LAUNCHER_PATH/build.sh"
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Instructions Volume :${NC} $VOLUME_INSTRUCTIONS"

# Vérification de l'existence des fichiers
file_check

#  Définir les instructions GPU en fonction du GPU détecté
gpu_create_instructions
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Instructions Device GPU :${NC} $DEVICE_INSTRUCTIONS"
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Instructions Env GPU :${NC} $ENV_INSTRUCTIONS"

# Création du fichier docker-compose.yml :
create_docker_compose



# ----------------------------- BUILD  ----------------------------#


# Information utilisateur 
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${GREEN}[3] - Build"
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Merci de vérifier les informations au-dessus, début dans ${NC}$SHOW_INFO_DELAY second(s)."
echo ""
sleep $SHOW_INFO_DELAY

# Build du container avec docker-compose
cd "./$LAUNCHER_PATH"
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Construction du container Docker... ${NC}"
docker-compose build || handle_error "Erreur lors de la construction du container Docker. Note : si vous utilisez Docker Desktop, assurez-vous qu'il soit lancé."

# Lancement du container avec docker-compose
echo ""
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Lancement du container Docker... ${NC}"
docker-compose up -d || handle_error "Erreur lors du lancement du container Docker. Note : si vous utilisez Docker Desktop, assurez-vous qu'il soit lancé. "
cd "../"

# Fin programme
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Container Docker lancé avec succès ! ${NC}"
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${GREEN}Press any key to exit the program...${NC}"
read -r
exit 1
# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOCKER_COMPOSE_FILE="docker-compose.yml"
DOCKER_FILE="Dockerfile"
HOST_VOLUME_PATH="/home/$USERNAME/ros2_ws"


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
    
    if [ "$(lspci | grep -i nvidia)" ]; then
        GPU="NVIDIA"
        elif [ "$(lspci | grep -i amd)" ]; then
        GPU="AMD"
        elif [ "$(lspci | grep -i intel)" ]; then
        GPU="INTEL"
    else
        GPU="UNKNOWN"
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





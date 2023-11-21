#!/bin/bash

# Définition du temps d'affichage des informations :
SHOW_INFO_DELAY=5

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

# EXPORT
export RED GREEN YELLOW BLUE NC
export GPU
export USERNAME
export LAUNCHER_PATH

# Fonction de gestion des erreurs
handle_error() {
    echo -e "${NC}[${RED}⨯${NC}] ${RED}$1"
    echo -e "${NC}[${RED}⨯${NC}] ${RED}Press any key to exit the program...${NC}"
    read -r
    exit 1
}

# Exporter la fonction pour la rendre accessible dans les scripts appelés
export -f handle_error

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
echo -e "${NC}[${BLUE}🛈${NC}] ${BLUE}Utilisateur actuel : ${NC} $USERNAME"
echo -e "${NC}[${BLUE}🛈${NC}] ${BLUE}Dépendences : ${NC} python, docker-compose"

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

# Information utilisateur - DEBUT DE TEST
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${BLUE}Démarrage vérification..."
echo ""
cd "./$LAUNCHER_PATH"

# Vérification intégrité fichier test
if [ ! -f "build.sh" ]; then
    handle_error "Erreur : impossible de trouver le fichier de vérification de l'OS (./$LAUNCHER_PATH/build.sh)."
fi

# Lancement des tests
./build.sh
BUILD_EXIT_CODE=$?  # Récupère le code de sortie de verif.sh

# Vérifie si verif.sh s'est terminé avec une erreur
if [ $BUILD_EXIT_CODE -ne 0 ]; then
    exit 1  # Arrête AreceEnv.sh si verif.sh a échoué
fi

# Information utilisateur - FIN DE TEST 
echo ""
echo -e "${NC}[${BLUE}✔${NC}] ${BLUE}Vérification terminée."
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
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Container Docker lancé avec succès ! ${NC}"

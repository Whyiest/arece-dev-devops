#!/bin/bash

# Définition du temps d'affichage des informations :
SHOW_INFO_DELAY=5

# Stockage du nom d'utilisateur dans une variable
USERNAME=$(whoami)

# Déclaration de la variable GPU
GPU="UNKNOWN"

# Default Path
MAC_FOLDER_PATH='./MacLauncher'
WINDOWS_FOLDER_PATH='./WindowsLauncher'
LINUX_FOLDER_PATH='./LinuxLauncher'

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


# Définition des paths
LAUNCHER_PATH=""


if [ "$OS_CHOICE" = "mac" ]; then
    # ARM ONLY
    LAUNCHER_PATH="$MAC_FOLDER_PATH"
    elif [ "$OS_CHOICE" = "windows" ]; then
    #X86 ONLY
    LAUNCHER_PATH="$WINDOWS_FOLDER_PATH"
    elif [ "$OS_CHOICE" = "linux" ]; then
    #X86 ONLY
    LAUNCHER_PATH="$LINUX_FOLDER_PATH"

else
    echo -e "${NC}[${RED}⨯${NC}] Erreur : choix invalide, votre os n'est pas pris en charge. Veuillez choisir 'mac' ou 'windows'. ${NC}"
    echo ""
    exit 1
fi


# Information utilisateur - DEBUT DE TEST
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${BLUE}Démarrage vérification..."
echo ""
cd "$LINUX_FOLDER_PATH"
./verif.sh || { echo -e "${NC}[${RED}⨯${NC}] Erreur lors de l'exécution du script verif.sh.${NC}"; exit 1; }

# Information utilisateur - FIN DE TEST 
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
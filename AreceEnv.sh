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

# Fonction de gestion des erreurs
handle_error() {
    echo -e "${NC}[${RED}⨯${NC}] ${RED}$1"
    echo -e "${RED}Press any key to continue...${NC}"
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
echo -e "${GREEN}Si test vous avez déjà lancé et créé une instance Docker avec cet outil, supprimez-la avec docker kill [instance] et effacez les fichiers liés."
echo ""

# Affichage du nom d'utilisateur
echo -e "${BLUE}Utilisateur actuel : ${NC} $USERNAME"

# Demande à l'utilisateur de son consentemment d'installation
echo -ne "${BLUE}Voulez-vous lancer l'installation de l'environnement ARECE ? (${NC}y/n${BLUE}) : ${NC}"
read INSTALL_CHOICE

if [ "$INSTALL_CHOICE" = "y" ]; then
    echo ""
elif [ "$INSTALL_CHOICE" = "n" ]; then
    handle_error "Annulation de l'installation."

else
    handle_error "Choix non reconnu, annulation."
fi

# Demande à l'utilisateur de choisir entre Mac et Windows
echo -ne "${BLUE}Choisissez votre système d'exploitation (${NC}mac/windows/linux${BLUE}) : ${NC}"
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
    handle_error "Erreur : choix invalide, votre os n'est pas pris en charge."
fi

# Information utilisateur - DEBUT DE TEST
echo ""
echo -e "${NC}[${GREEN}⧁${NC}] ${BLUE}Démarrage vérification..."
echo ""
cd "$LINUX_FOLDER_PATH"

./verif.sh
VERIF_EXIT_CODE=$?  # Récupère le code de sortie de verif.sh

# Vérifie si verif.sh s'est terminé avec une erreur
if [ $VERIF_EXIT_CODE -ne 0 ]; then
    exit 1  # Arrête AreceEnv.sh si verif.sh a échoué
fi

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
docker-compose build || handle_error "Erreur lors de la construction du container Docker."

# Lancement du container avec docker-compose
echo ""
echo -e "${NC}[${BLUE}⧁${NC}] ${BLUE}Lancement du container Docker... ${NC}"
docker-compose up -d || handle_error "Erreur lors du lancement du container Docker."

# Fin programme
echo ""
echo -e "${NC}[${GREEN}✔${NC}] ${BLUE}Container Docker lancé avec succès ! ${NC}"

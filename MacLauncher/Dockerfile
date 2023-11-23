# Utiliser l'image ROS Humble avec Ubuntu Jammy
FROM ros:humble-ros-core-jammy

# Mise à jour des paquets et installation de Zsh
RUN apt update && apt install zsh -y

# Définition de Zsh comme le shell par défaut
SHELL [ "/bin/zsh", "-c"]

# Installation de sudo et configuration d'un utilisateur non-root
RUN apt install sudo -y
RUN useradd -m arece && echo "arece:arece" | chpasswd && adduser arece sudo

# Configuration de sudo pour permettre à l'utilisateur de l'utiliser sans mot de passe
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Passage à l'utilisateur créé
USER arece

# Installation des outils de base
RUN sudo apt install curl git nano -y

# Installation des dépendances pour le développement ROS et Gazebo
RUN sudo apt install software-properties-common -y
RUN sudo add-apt-repository ppa:tobhe/asahi -y
RUN sudo apt install libgl1-mesa-dri -y
RUN sudo apt install ros-humble-rviz2 -y
RUN sudo add-apt-repository ppa:openrobotics/gazebo11-non-amd64
RUN sudo apt install gazebo -y
RUN sudo apt install python3-pip -y
RUN pip3 install colcon-common-extensions
RUN sudo apt install python3-rosdep -y
RUN sudo rosdep init
RUN rosdep update

# Configuration de l'environnement de travail pour Gazebo
WORKDIR /home/arece/gazebo_ws
RUN mkdir src && cd src && git clone -b ros2 --single-branch https://github.com/ros-simulation/gazebo_ros_pkgs.git
RUN rosdep install --from-paths src --ignore-src -r -y
RUN sudo apt install python3-colcon-common-extensions \
ros-humble-gazebo-dev ros-humble-rqt-graph ros-humble-ackermann-msgs ros-humble-joint-state-publisher \
ros-humble-xacro libpcl-dev libyaml-cpp-dev ros-humble-plotjuggler ros-humble-plotjuggler-ros -y
RUN source /opt/ros/humble/setup.zsh; colcon build

# Ajout des scripts de configuration ROS au fichier .bash
RUN echo "source /opt/ros/humble/setup.zsh" >> /home/arece/.bashrc
RUN echo "source /home/arece/gazebo_ws/install/setup.zsh" >> /home/arece/.bashrc
RUN echo "source /home/arece/ros2_ws/install/setup.zsh" >> /home/arece/.bashrc
RUN echo "export ARECE_MASTER=~/ros2_ws/src" >> /home/arece/.bashrc

# Installation des paquets supplémentaires pour le développement ROS
RUN sudo apt install python3-pytest ros-humble-robot-state-publisher ros-humble-stereo-image-proc libpyside2-dev libshiboken2-dev pyqt5-dev \
python3-pyqt5 python3-pyqt5.qtsvg python3-pyside2.qtsvg python3-sip-dev shiboken2 python3-pil python3-pandas python3-numpy \
python3-matplotlib python3-scipy python3-yaml libyaml-cpp-dev gazebo -y

# Configuration de l'espace de travail ROS
WORKDIR /home/arece/ros2_ws

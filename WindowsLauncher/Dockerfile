FROM ros:humble-ros-core-jammy

# Ajout de l'utilisateur ARECE et configuration de sudo
RUN apt-get update && apt-get install -y sudo \
    && useradd -m ARECE \
    && echo "ARECE ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ARECE \
    && chmod 0440 /etc/sudoers.d/ARECE

# Changement d'utilisateur à ARECE
USER ARECE

# Mise à jour et installation des paquets nécessaires
RUN sudo apt-get update && sudo apt-get install -y \
    git \
    nano \
    software-properties-common \
    python3-pip \
    python3-rosdep

# Configuration de ROS
RUN sudo rosdep init && sudo rosdep update

# Installation des dépendances pour ROS et Gazebo
RUN sudo apt-get install -y \
    ros-humble-rviz2 \
    gazebo \
    python3-colcon-common-extensions \
    ros-humble-gazebo-dev \
    ros-humble-rqt-graph \
    ros-humble-ackermann-msgs \
    ros-humble-joint-state-publisher \
    ros-humble-xacro \
    libpcl-dev \
    libyaml-cpp-dev \
    ros-humble-plotjuggler \
    ros-humble-plotjuggler-ros \
    python3-pytest \
    ros-humble-robot-state-publisher \
    ros-humble-stereo-image-proc \
    libpyside2-dev \
    libshiboken2-dev \
    pyqt5-dev \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
    python3-pyside2.qtsvg \
    python3-sip-dev \
    shiboken2 \
    python3-pil \
    python3-pandas \
    python3-numpy \
    python3-matplotlib \
    python3-scipy \
    python3-yaml \
    libyaml-cpp-dev


# Permet d'exécuter le setup.sh
RUN sudo /bin/bash -c '. /opt/ros/humble/setup.sh; colcon build'

# Configuration de l'environnement à chaque exécution d'un terminal bash
RUN echo "source /opt/ros/humble/setup.sh" | sudo tee -a /home/ARECE/.bashrc
RUN echo "source /gazebo_ws/install/setup.sh" | sudo tee -a /home/ARECE/.bashrc

# Configurer le répertoire par défaut du terminal
WORKDIR /home/ARECE/ros2_ws
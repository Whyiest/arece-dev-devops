# Installation de ros :
FROM ros:humble-ros-core-jammy

# Mise à jour des paquets et installation de sudo
RUN apt-get update && apt-get install -y sudo

# Ajout de l'utilisateur ARECE et configuration de sudo
RUN useradd -m arece \
    && echo "arece ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/arece \
    && chmod 0440 /etc/sudoers.d/arece

# Changement d'utilisateur à ARECE
USER arece

# Mise à jour et installation des paquets nécessaires
RUN sudo apt-get update && sudo apt-get install -y \
    curl \
    git \
    nano \
    software-properties-common \
    python3-pip \
    python3-rosdep

# Configuration de ROS
RUN sudo rosdep init && rosdep update

# Installation des dépendances pour ROS et Gazebo
RUN sudo apt-get install -y \
    ros-humble-rviz2 \
    apt-utils \
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



RUN sudo /bin/bash -c '. /opt/ros/humble/setup.bash; colcon build'

# Configuration de l'environnement à chaque exécution d'un terminal bash
RUN sudo echo "source /opt/ros/humble/setup.bash" | sudo tee -a /home/arece/.bashrc
RUN sudo echo "source /home/arece/gazebo_ws/install/setup.bash" >> /home/arece/.bashrc
RUN sudo echo "source /home/arece/ros2_ws/install/setup.bash" >> /home/arece/.bashrc
RUN sudo echo "export ARECE_MASTER=~/ros2_ws/src" >> /home/arece/.bashrc

# Configuration de l'espace de travail pour Gazebo
WORKDIR /home/arece/gazebo_ws


# Configuration de l'espace de travail pour ROS
WORKDIR /home/arece/ros2_ws


FROM ros:humble-ros-core-jammy
RUN apt update && apt install zsh -y
SHELL [ "/bin/zsh", "-c"]
RUN apt install sudo -y
RUN useradd -m arthur && echo "arthur:arthur" | chpasswd && adduser arthur sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER arthur
RUN sudo apt install curl git nano -y
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
COPY .zshrc /home/arthur/.zshrc
COPY .p10k.zsh /home/arthur/.p10k.zsh
RUN sudo chmod 777 /home/arthur/.zshrc
RUN sudo chmod 777 /home/arthur/.p10k.zsh
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
WORKDIR /home/arthur/gazebo_ws
RUN mkdir src && cd src && git clone -b ros2 --single-branch https://github.com/ros-simulation/gazebo_ros_pkgs.git
RUN rosdep install --from-paths src --ignore-src -r -y
RUN sudo apt install python3-colcon-common-extensions \
ros-humble-gazebo-dev ros-humble-rqt-graph ros-humble-ackermann-msgs ros-humble-joint-state-publisher \
ros-humble-xacro libpcl-dev libyaml-cpp-dev ros-humble-plotjuggler ros-humble-plotjuggler-ros -y
RUN source /opt/ros/humble/setup.zsh; colcon build
RUN echo "source /opt/ros/humble/setup.zsh" >> /home/arthur/.zshrc
RUN echo "source /home/arthur/gazebo_ws/install/setup.zsh" >> /home/arthur/.zshrc
RUN echo "source /home/arthur/ros2_ws/install/setup.zsh" >> /home/arthur/.zshrc
RUN echo "export ARECE_MASTER=~/ros2_ws/src" >> /home/arthur/.zshrc
RUN sudo apt install python3-pytest ros-humble-robot-state-publisher ros-humble-stereo-image-proc libpyside2-dev libshiboken2-dev pyqt5-dev \
python3-pyqt5 python3-pyqt5.qtsvg python3-pyside2.qtsvg python3-sip-dev shiboken2 python3-pil python3-pandas python3-numpy \
python3-matplotlib python3-scipy python3-yaml libyaml-cpp-dev gazebo -y
WORKDIR /home/arthur/ros2_ws
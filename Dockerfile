FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ENV DISPLAY=host.docker.internal:0.0

RUN apt -y update && apt -y upgrade && apt -y install curl git cmake build-essential gnupg2  lsb-release sudo locales

RUN locale-gen en_US en_US.UTF-8 
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN LANG=en_US.UTF-8
RUN apt -y update && apt install -y software-properties-common && add-apt-repository universe
RUN sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN apt -y update && apt install -y python3-colcon-common-extensions\
  libbullet-dev \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  wget \
    libasio-dev \
  libtinyxml2-dev \
  libxml2-utils \
    qtbase5-dev  \
    libcunit1-dev 
    libgtest-dev \
    && \
    rm -rf /var/lib/apt/lists
    
RUN python3 -m pip install -U \
      argcomplete \
      flake8-blind-except \
      flake8-builtins \
      flake8-class-newline \
      flake8-comprehensions \
      flake8-deprecated \
      flake8-docstrings \
      flake8-import-order \
      flake8-quotes \
      pytest-repeat \
      pytest-rerunfailures \
      pytest

RUN mkdir -p ~/ros2_foxy/src && \
    cd ~/ros2_foxy && vcs import --input https://raw.githubusercontent.com/ros2/ros2/foxy/ros2.repos src 
    
RUN apt upgrade && \
    rosdep init && \
    rosdep update && \
    cd ~/ros2_foxy && rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-5.3.1 urdfdom_headers"

RUN cd ~/ros2_foxy/ && \
    colcon build --symlink-install
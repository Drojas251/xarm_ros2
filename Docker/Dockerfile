# Install ROS 2 Galactic
FROM ros:galactic-ros-base-focal

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-galactic-desktop=0.9.3-2* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get upgrade -y 

# Install required packages
RUN apt-get install -y \
    ros-galactic-moveit  \
    ros-galactic-ros2-control \
    ros-galactic-ros2-controllers \
    git-all \
    xauth \
    && apt-get clean

# Add ROS 2 setup to bashrc
RUN echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Clone and install xarm_ros2 repository
WORKDIR /home/xarm_ws/src
RUN git clone https://github.com/xArm-Developer/xarm_ros2.git --recursive -b galactic

WORKDIR /home/xarm_ws/src/xarm_ros2
RUN git pull \
    && git submodule sync \
    && git submodule update --init --remote

WORKDIR /home/xarm_ws/src
RUN rosdep update --include-eol-distros \
    && rosdep install --from-paths . --ignore-src --rosdistro galactic -y

WORKDIR /home/xarm_ws
RUN /bin/bash -c "source /opt/ros/galactic/setup.bash && colcon build"

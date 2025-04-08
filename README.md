## xarm_ros2
This repo setups an environment for running xarm_ros2 on a ubuntu 20.04 machine. The offical xarm_ros2 repo which is used here is [here](https://github.com/xArm-Developer/xarm_ros2/tree/galactic). There you can find the official documentation for the xarm_ros2 package and examples for using the xarm_ros2 package. The following instructions will guide you through setting up the environment and running the xarm_ros2 package on any machine that is compatible with docker.

## Docker Installation

Helper scripts for installing docker on ubuntu and mac are in the Docker/docker_install folder.

For ubuntu, run the following script:

```bash
./Docker/docker_install/docker_install_ubuntu.sh
```

For mac, run the following script:

```bash
./Docker/docker_install/docker_install_mac.sh
```

Docker should now be setup. Run the following command to test it:

```bash
docker run hello-world
```

If docker is setup correctly, you should see a message saying "Hello from Docker!".

## xarm_ros2 Docker Setup

To build the docker image, run the script in xarm_ros2/Docker/build.sh.

```bash
./xarm_ros2/Docker/build.sh
```

This will build and environment which installs ros2 galactic on ubuntu 20.04, and installs the xarm_ros2 package.

To run the docker image, run the script in xarm_ros2/Docker/launch.sh.

```bash
./xarm_ros2/Docker/launch.sh
```

This will run the docker image and put you in a bash shell in the docker container, in the /home/xarm_ws directory.

## xarm_ros2 Workspace Setup

To setup the xarm_ros2 workspace in the docker container, run the script from /home/xarm_ws. This will setup workspace environment variables so
ros2 knows about custom ros2 packages, custom data structures, and custom launch files.

```bash
source install/setup.bash
```

To make sure the workspace is setup correctly, run the following command:

```bash
ros2 launch xarm_description lite6_rviz_display.launch.py add_gripper:=true
```

This will launch the demo launch file, which will display the xarm in rviz.

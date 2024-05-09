# Start from ROS base image
FROM osrf/ros:noetic-desktop-full-focal

# Set the working directory
WORKDIR /

# Make a catkin workspace
RUN mkdir -p /catkin_ws/src

# Change the default shell to Bash
SHELL ["/bin/bash", "-c"]

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 && \
    ln -s /usr/bin/python3 /usr/bin/python

# git clone packages of tortoisebot
RUN git clone -b noetic https://github.com/rigbetellabs/tortoisebot.git /catkin_ws/src/tortoisebot

#git clone tortoisebot_waypoints packages
RUN git clone https://github.com/morg1207/tortoisebot_waypoints_ros1_test.git /catkin_ws/src/tortoisebot/tortoisebot_waypoints

# Build the Catkin workspace
RUN source /opt/ros/noetic/setup.bash \
    && cd /catkin_ws \
    && catkin_make

# Config workspace
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc 

# Set the entry point to start the ROS launch file
ENTRYPOINT ["/bin/bash", "-c", "source /catkin_ws/devel/setup.bash && roslaunch tortoisebot_gazebo tortoisebot_playground.launch"]
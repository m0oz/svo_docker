FROM ros:kinetic-perception-xenial

RUN apt-get update && apt-get install -y \
    python-catkin-tools \
    libopencv-dev \
    ros-kinetic-rqt \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --gecos "ROS User" --disabled-password ros
RUN usermod -a -G dialout ros
USER ros

RUN mkdir -p /home/ros/svo_ws/src
WORKDIR /home/ros/svo_ws
RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash; catkin_init_workspace /home/ros/svo_ws/src'

# SVO dependencies
RUN mkdir -p /home/ros/svo_dependency_ws/
WORKDIR /home/ros/svo_dependency_ws
# Sophus
RUN git clone https://github.com/strasdat/Sophus.git
RUN /bin/bash -c 'cd Sophus; git checkout a621ff;'
# Apply fix for known Sophus bug
COPY docker/so2.cpp Sophus/sophus
RUN /bin/bash -c 'mkdir Sophus/build; cd Sophus/build; cmake ..'
RUN /bin/bash -c 'cd Sophus/build; make'
# Fast corner detector
RUN git clone https://github.com/uzh-rpg/fast.git
RUN /bin/bash -c 'cd fast; git checkout 1153981;'
RUN /bin/bash -c 'mkdir fast/build; cd fast/build; cmake ..'
RUN /bin/bash -c 'cd fast/build; make'

#SVO
WORKDIR /home/ros/svo_ws
COPY svo src/svo
COPY svo_ros src/svo_ros
COPY svo_msgs src/svo_msgs
COPY svo_analysis src/svo_analysis
COPY rqt_svo src/rqt_svo
RUN /bin/bash -c 'cd src; git clone https://github.com/uzh-rpg/rpg_vikit.git'
RUN /bin/bash -c 'cd src/rpg_vikit; git checkout 10871da;'

# catkin build
RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash; catkin build --force-cmake'
RUN echo "source /home/ros/svo_ws/devel/setup.bash" >> /home/ros/.bashrc

# Entrypoint
COPY docker/ros_entrypoint.sh /home/ros/
ENTRYPOINT ["/home/ros/ros_entrypoint.sh"]
CMD ["bash"]

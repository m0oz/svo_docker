#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/kinetic/setup.bash"
source "/home/ros/svo_ws/devel/setup.bash"

exec "$@"

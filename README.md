SVO
===

This fork offers a dockerized version of SVO, making it fit to run on any OS that runs docker.
I used it to test the SVO pipeline on Mac OS and deploy it on a Raspi4 running Raspbian Buster.
Having a containerized version of SVO makes sure that we can use a Ubuntu16.04 image and saves us from the hasstle of build ros and other dependencies from source on any new system that we want to deploy the pipieline on. This is especially true for Raspbian Buster, as currently there are no ROS binaries available for this distribution

## How to build and run the docker container

 - Install [docker](https://docs.docker.com/v17.12/install/) on any OS
 - From this repos root:
        
        cd docker
        docker build -t ros_svo .
 
 To run the image invoke: ```docker run -it ros_svo```

#!/bin/bash
# Setup script for the (robot_manip_ws) environment
# Requires sudo privileges
#
# Usage: 
#   sudo ./setup_download.sh
# -----------------------------------------------------------------------------

# defining warning header
read -r -d '' warning_header << EOM
(Download) setup script for the (robot_manip_ws) environment

SUDO PRIVILEGES AND A STABLE INTERNET CONNECTION ARE REQUIRED

WARNING
-------

DO NOT INTERRUPT EXECUTION ONCE THE SCRIPT IS STARTED.
DO NOT RE-RUN THIS SCRIPT ONCE THE ENVIRONMENT IS SET UP.

This script requires 16GB of disk space. 

It will perform the following : 
    1) Setup docker on the machine
    2) Download the (book_simulations) docker container in which all gazebo simulations will run
    3) Clone the mobile_manip_notebooks repository and place it next to the (robot_manip_ws) folder
EOM

# displaying the script warning + handling user input
echo -e "\n$warning_header\n\n"
read -p "Type (yes) if you wish to continue, or anything else to abort : " warning_input
if [ $warning_input != "yes" ]; then
    echo -e "\n\nAborting execution.\n\n"
    exit
fi

echo -e "\n\nInstalling general dependencies ... \n\n"
apt-get install -y curl git

echo -e "\n\nCloning the (mobile_manip_notebooks) repository \n\n"
# check to prevent crushing (mobile_manip_notebooks) 
if [ -d "mobile_manip_notebooks" ]; then
    echo -e "\n\nThe (mobile_manip_notebooks) repository already exists - cloning aborted.\n\n"
else
    git clone https://github.com/Foundations-of-Robotics/mobile_manip_notebooks
    chmod -R 777 mobile_manip_notebooks/
fi

# TODO : Change path to the public version of the repo, once it's available
echo -e "\n\nCloning the (robot_manip_ws) repository ... requires user credentials"
git clone -b noetic_docker https://git.initrobots.ca/Nerea/robot_manip_ws.git
chmod -R 777 robot_manip_ws/docker/

echo -e "\n\nSetting up docker ... \n\n"

if [ -x "$(command -v docker)" ]; then
    echo -e "\n\nDocker is already installed.\n\n"
else
    apt-get remove -y docker docker-engine docker.io containerd runc
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

echo -e "\n\Downloading the (book_simulations) docker container ...\n\n"

# wget (insert url to the book_simulations.tar.gz file)
docker load < book_simulations.tar.gz
rm book_simulations.tar.gz

echo -e "\n\Setup complete .\n\n"
#!/bin/bash
#
# Copyright (c) 2019 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause 
#

clear
echo
echo "The features and functionality included in this reference design"
echo "are intended to showcase the capabilities of the Intel® RSP by"
echo "demonstrating the use of the API to collect and process RFID tag"
echo "read information. THIS SOFTWARE IS NOT INTENDED TO BE A COMPLETE"
echo "END-TO-END INVENTORY MANAGEMENT SOLUTION."
echo
echo "This script will download and install the Intel® RSP SW Toolkit-"
echo "Gateway monolithic Java application along with its dependencies."
echo "This script is designed to run on Debian 9 or Ubuntu 18.04 LTS."
echo 
echo "This script will also download and install the latest software"
echo "repository for Intel® RFID Sensor Platforms (H1000/H3000/H4000)."
echo "By continuing with this installation, you agree to the terms in"
echo "the End User License Agreemnt Intel-RSP-EULA-Agreement.pdf."
echo "https://github.com/intel/rsp-sw-toolkit-installer/sensor-sw-repo"
echo
echo "IMPORTANT! PLEASE READ AND AGREE TO THIS EULA BEFORE CONTINUING!"
echo 
read -p 'Press [Enter] to continue... or [Ctrl]-[C] to exit...'
echo
CURRENT_DIR=$(pwd)

echo "Checking Internet connectivity"
echo
PING1=$(ping -c 1 8.8.8.8)
PING2=$(ping -c 1 pool.ntp.org)
if [[ $PING1 == *"unreachable"* ]]; then
    echo "ERROR: No network connection found, exiting."
    exit 1
elif [[ $PING1 == *"100% packet loss"* ]]; then
    echo "ERROR: No Internet connection found, exiting."
    exit 1
else
    if [[ $PING2 == *"not known"* ]]; then
        echo "ERROR: Cannot resolve pool.ntp.org."
        echo "Is your network blocking IGMP ping?"
        echo "exiting"
        exit 1
    else
        echo "Connectivity OK"
    fi
fi

echo
echo "Installing the following dependencies..."
echo "    1. tar"
echo "    2. openjdk"
echo "    3. git"
echo "    4. gradle"
echo "    5. mosquitto"
echo "    6. mosquitto-clients"
echo "    7. avahi-daemon"
echo "    8. ntp"
echo "    9. ssh"
echo
sudo apt update
sudo apt -y install tar default-jdk git gradle 
sudo apt -y install mosquitto mosquitto-clients avahi-daemon
sudo apt -y install ntp ntp-doc ssh
sudo apt -y autoremove

echo
cd ~
HOME_DIR=$(pwd)
PROJECTS_DIR=$HOME_DIR/projects
DEPLOY_DIR=$HOME_DIR/deploy

if [ ! -d "$PROJECTS_DIR" ]; then
    echo "Creating the projects directory..."
    mkdir $PROJECTS_DIR
fi
cd $PROJECTS_DIR

echo
GIT_VERSION=$(git --version)
if [[ $GIT_VERSION == *"git version"* ]]; then
    echo "Cloning the RSP SW Toolkit - Gateway..."
else
    echo "git did not install properly, exiting."
    exit 1
fi
if [ ! -d "$PROJECTS_DIR/rsp-sw-toolkit-gw" ]; then
    cd $PROJECTS_DIR
    git clone https://github.com/intel/rsp-sw-toolkit-gw.git
fi
cd $PROJECTS_DIR/rsp-sw-toolkit-gw
git pull

echo
GRADLE_VERSION=$(gradle --version)
if [[ $GRADLE_VERSION == *"Revision"* ]]; then
    echo "Deploying the RSP SW Toolkit - Gateway..."
else
    echo "gradle did not install properly, exiting."
    exit 1
fi
gradle clean deploy

JAVA_HOME=$(type -p java)
if [[ $JAVA_HOME == *"java"* ]]; then
    echo
else
    echo "java did not install properly, exiting."
    exit 1
fi
RUN_DIR=$DEPLOY_DIR/rsp-sw-toolkit-gw
cd $RUN_DIR

if [ ! -d "$RUN_DIR/cache" ]; then
    echo "Creating cache directory..."
    mkdir ./cache
    echo "Generating certificates..."
    cd ./cache && ../gen_keys.sh
fi
echo
if [ ! -f "$RUN_DIR/cache/keystore.p12" ]; then
    echo "Certificate creation failed, exiting."
    exit 1
fi

if [ ! -d "$PROJECTS_DIR/rsp-sw-toolkit-installer/sensor-sw-repo" ]; then
    echo "Downloading the sensor software repository..."
    cd $PROJECTS_DIR
    git clone https://github.com/intel/rsp-sw-toolkit-installer.git
fi
cd $PROJECTS_DIR/rsp-sw-toolkit-installer/
git pull
cd $PROJECTS_DIR/rsp-sw-toolkit-installer/sensor-sw-repo

TAR_BALL=$(ls hx000-rrs-repo-*.tgz)
GIT_LFS_VERSION=$(git lfs --version)
if [[ $GIT_LFS_VERSION == *"git-lfs/"* ]]; then
    echo "Package git-lfs exists, continuing..."
else
    echo "Using wget to download sensor software repository..."
    rm $PROJECTS_DIR/rsp-sw-toolkit-installer/sensor-sw-repo/*.tgz
    wget https://github.com/intel/rsp-sw-toolkit-installer/raw/master/sensor-sw-repo/$TAR_BALL
fi
if [ -f "$TAR_BALL" ]; then
    echo "Copying sensor software repository to deploy folder..."
    tar -xf ./$TAR_BALL
    REPO_DIR=${TAR_BALL::-4}
    if [ ! -d "$RUN_DIR/sensor-sw-repo/" ]; then
        mkdir $RUN_DIR/sensor-sw-repo/
    fi
    cp -R ./$REPO_DIR/* $RUN_DIR/sensor-sw-repo/
fi

echo
cd $PROJECTS_DIR/rsp-sw-toolkit-installer/native
if [ ! -f "$PROJECTS_DIR/rsp-sw-toolkit-installer/native/open-web-admin.sh" ]; then
    echo "WARNING: The script open-web-admin.sh was not found."
else
    ./open-web-admin.sh &
fi
echo "Running the RSP SW Toolkit - Gateway..."
cd $RUN_DIR
./run.sh

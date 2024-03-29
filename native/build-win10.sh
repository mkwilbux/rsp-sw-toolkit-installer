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
echo "This script is designed to run in a Windows 10 Git Bash terminal."
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
cd ~
HOME_DIR=$(pwd)
PROJECTS_DIR=$HOME_DIR/projects
DEPLOY_DIR=$HOME_DIR/deploy
PATH=$PATH':/c/Program Files/openjdk/bin'

if [ ! -d "$PROJECTS_DIR" ]; then
    echo "Creating the projects directory..."
    mkdir $PROJECTS_DIR
fi
cd $PROJECTS_DIR

echo
echo "Cloning the RSP SW Toolkit - Gateway..."
if [ ! -d "$PROJECTS_DIR/rsp-sw-toolkit-gw" ]; then
    cd $PROJECTS_DIR
    git clone https://github.com/intel/rsp-sw-toolkit-gw.git
fi
cd $PROJECTS_DIR/rsp-sw-toolkit-gw
git pull
./gradlew.bat clean deploy

RUN_DIR=$DEPLOY_DIR/rsp-sw-toolkit-gw
cd $RUN_DIR
echo
if [ ! -d "$RUN_DIR/cache" ]; then
    echo "Creating cache directory..."
    mkdir ./cache
    echo "Generating certificates..."
    cd ./cache && ../gen_keys.bat
fi
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
echo "Running the RSP SW Toolkit - Gateway..."
cd $RUN_DIR
./run.bat


# Sensor Software Repository

The Intel® RFID Sensor Platform (Intel® RSP) is a Linux based device whose operating system is built using the Yocto Project.  Updates to the packages in this device are released periodically in the form of an opkg repository.  When this repository is placed into the "deploy/rsp-sw-toolkit-gw/sensor-sw-repo" directory, each Intel® RSP will automatically update its software from this repository when connected to the Intel® RSP Controller application.  To comply with open source requirements, the source code for the various open source libraries used in creating the Hx000 software is also included here.  The files in this directory are...

    > Intel-RSP-EULA-Agreement.pdf
    > OpenSourceLibraries.url        (url to download the open source libraries) 
    > hx000-rrs-repo-yy.q.mm.dd.tgz  (yy.q.mm.dd is the opkg repository version)

The terms of use for this software are outlined in the Intel® RSP EULA Agreement.  **_IMPORTANT! PLEASE READ AND AGREE TO THIS EULA BEFORE DOWNLOADING THIS SOFTWARE_**


## Getting Started

If you are using one of the build.sh scripts from either the native, docker or edge-x directories, the sensor-sw-repo will automatically be installed.  However, if you only need to install an updated version, use the update.sh script from this repository and follow the steps outlined below.


### Clone the RSP Installer Repository 

``` 
mkdir -p ~/projects
cd ~/projects

sudo apt -y install git
git clone https://github.com/intel/rsp-sw-toolkit-installer.git
```

### Execute the Update Script 

```
cd ~/projects/rsp-sw-toolkit-installer/sensor-sw-repo
./update.sh
```

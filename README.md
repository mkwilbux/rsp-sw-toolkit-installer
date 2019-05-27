# Installer

The features and functionality included in this reference design are intended to showcase the capabilities of the Intel® RFID Sensor Platform (Intel® RSP) by demonstrating the use of the API to collect and process RFID tag read information. **_THIS SOFTWARE IS NOT INTENDED TO BE A COMPLETE END-TO-END INVENTORY MANAGEMENT SOLUTION._**

## Getting Started

This repository contains installation scripts that provide the "Easy Button" for installing the Intel® RSP SW Toolkit - Gateway.  There are three directories corresponding to the three different methods of deploying.  These scripts are intended to run in a Debian Linux environment ONLY.


### Native Linux

This method will download and install the Intel® RSP SW Toolkit - Gateway source code along with all of its runtime dependencies.  The script will build the source code and run the Java application along with spawining a web browser to view the Web Admin console.  Clone this repository if you are familiar with how to do that.  Otherwise, use the web interface to download both build.sh and open-web-admin.sh.  Place them in your home directory and run the build.sh script.


### Docker Environment

This method will download and install the Intel® RSP SW Toolkit - Gateway source code along with all of its runtime dependencies within a Docker environment.  The script will build and deploy three separate Docker Containers.  Clone this repository if you are familiar with how to do that.  Otherwise, use the web interface to download the build.sh script.  Place it in your home directory and run it as root (i.e. sudo ./build.sh).


### Edge-X Environment (coming soon)

This method will download and install the Intel® RSP SW Toolkit - Gateway source code along with all of its runtime dependencies within an Edge-X environment.  Check back later for more details.



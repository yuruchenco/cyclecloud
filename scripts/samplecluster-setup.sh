#!/bin/bash

echo "Installing git..."
sudo yum install -y git || { echo "Failed to install git"; exit 1; }

echo "Creating cyclecloud_projects directory..."
mkdir cyclecloud_projects || { echo "Failed to create directory"; exit 1; }
cd ~/cyclecloud_projects/
git clone https://github.com/Azure/cyclecloud-pbspro.git

cd ~/cyclecloud_projects/cyclecloud-pbspro/templates
wget https://raw.githubusercontent.com/0ht/cyclecloud/main/scripts/openpbs_hpc.txt

mkdir ~/cyclecloud_projects/cyclecloud-pbspro/blobs
cd ~/cyclecloud_projects/cyclecloud-pbspro/blobs
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/cyclecloud-pbspro-pkg-2.0.21.tar.gz
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/cyclecloud_api-8.3.1-py2.py3-none-any.whl
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/hwloc-libs-1.11.9-3.el8.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-client-20.0.1-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-client-22.05.11-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-execution-20.0.1-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-execution-22.05.11-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-server-20.0.1-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/openpbs-server-22.05.11-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/pbspro-client-18.1.4-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/pbspro-debuginfo-18.1.4-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/pbspro-execution-18.1.4-0.x86_64.rpm
wget https://github.com/Azure/cyclecloud-pbspro/releases/download/2.0.21/pbspro-server-18.1.4-0.x86_64.rpm

sudo chmod +x /usr/local/cyclecloud-cli/embedded/bin/azcopy

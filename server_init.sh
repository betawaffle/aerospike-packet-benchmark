#!/bin/bash

# Set Kernel Params
cat > /etc/sysctl.d/50-aerospike.conf <<EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65535
EOF
sysctl --system

# Install System Packages
apt-get install -y sudo htop sysstat jq

# Install Aerospike Tools
cd /root
wget -O aerospike-tools.tgz 'http://aerospike.com/download/server/latest/artifact/debian7'
tar -xvf aerospike-tools.tgz && cd aerospike-server-community-*
dpkg -i aerospike-tools-*.debian7.x86_64.deb

# Install Aerospike
cd /root
wget -O aerospike.tgz 'http://aerospike.com/download/server/latest/artifact/tgz'
tar -xvf aerospike.tgz && cd aerospike-server
./bin/aerospike init

# Configure Aerospike
private_ip=$(curl -s https://metadata.packet.net/metadata | jq -r '.network.addresses[2].address')
echo "${config}" > etc/aerospike.conf

# blkdiscard /dev/nvme0n1
# blkdiscard /dev/nvme1n1

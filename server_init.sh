#!/bin/bash

# Set Kernel Params
cat > /etc/sysctl.d/50-aerospike.conf <<EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65535
EOF
sysctl --system

# Tune Network IRQ
for i in $(seq 0 7); do
  irq0=$(grep "eth0-${i}\b" /proc/interrupts | awk '{print $1}')
  irq0=${irq0%:}
  # echo -n "${irq0} " >> eth-affinity.log
  # cat /proc/irq/${irq0}/smp_affinity >> eth-affinity.log
  printf "%08x\n" $(( 1 << ($i * 2) )) > /proc/irq/${irq0}/smp_affinity

  irq1=$(grep "eth1-${i}\b" /proc/interrupts | awk '{print $1}')
  irq1=${irq0%:}
  # echo -n "${irq1} " >> eth-affinity.log
  # cat /proc/irq/${irq1}/smp_affinity >> eth-affinity.log
  printf "%08x\n" $(( 1 << ($i * 2 + 16) )) > /proc/irq/${irq0}/smp_affinity
done

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

# Write Reset Script
cat > bin/reset <<EOF
#!/bin/bash

/root/aerospike-server/bin/aerospike stop
mv /root/aerospike-server/var/log/aerospike.log /root/aerospike-server/var/log/aerospike.$(ls -l /root/aerospike-server/var/log/aerospike*.log | wc -l).log
blkdiscard /dev/nvme0n1 &
blkdiscard /dev/nvme1n1 &
wait
EOF

# cd ~/aerospike-server
# ./bin/reset && taskset -c 1-32:2 ./bin/aerospike start

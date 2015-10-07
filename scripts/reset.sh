#!/bin/bash

/root/aerospike-server/bin/aerospike stop
mv /root/aerospike-server/var/log/aerospike.log /root/aerospike-server/var/log/aerospike.$(ls -l /root/aerospike-server/var/log/aerospike*.log | wc -l).log
blkdiscard /dev/nvme0n1 &
blkdiscard /dev/nvme1n1 &
wait

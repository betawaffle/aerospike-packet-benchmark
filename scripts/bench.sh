#!/bin/bash

cd /root/aerospike-client-java/benchmarks
./run_benchmarks -z 56 -n test -w I -o S:50 -b 3 -l 20 -latency 10,1 -h ${server_ip} -k 20000000 -S $(( $i * 20000000 ))

#!/bin/bash

# for q in $(seq 0 31); do
#   core=$(( $q - ($q % 2) ))
#
#   irq0=$(grep "nvme0q${q}\b" /proc/interrupts | awk '{print $1}')
#   irq0=${irq0%:}
#   echo -n "${irq0} " >> affinity.log
#   cat /proc/irq/${irq0}/smp_affinity >> affinity.log
#   printf "%08x\n" $(( 1 << $core )) > /proc/irq/${irq0}/smp_affinity
#
#   irq1=$(grep "nvme1q${q}\b" /proc/interrupts | awk '{print $1}')
#   irq1=${irq1%:}
#   echo -n "${irq1} " >> affinity.log
#   cat /proc/irq/${irq1}/smp_affinity >> affinity.log
#   printf "%08x\n" $(( 1 << $core )) > /proc/irq/${irq1}/smp_affinity
# done

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

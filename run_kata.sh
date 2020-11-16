repo="/mnt/oci"
idx=1
container="redis-${idx}"
cpumap="map.txt"
kata-runtime --log=/dev/stdout run \
             --detach \
             --telnet 127.0.0.1:$(( 7000 + idx )) \
             --monitor 127.0.0.1:$(( 8000 + idx )) \
             --vdisk hda,/shared/vm-images/kata.qcow2 \
             --sharedmem /mnt/hugetlb/memory,share=on \
             --hptapidx ${idx} \
             --cpumap ${cpumap} \
             --bundle "${repo}/${container}" \
             ${container}

#sleep 0.1
#sudo /shared/setup_vcpu.sh /run/vc/vm/redis-1/qmp.sock

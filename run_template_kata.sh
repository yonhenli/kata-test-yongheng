repo="/home/ubuntu/cocotion/vmcontainer/oci"
idx=0
container="redis-${idx}"
vdisk="hda,/home/ubuntu/directVisor/snap.qcow2"
#vdisk="hda,vm.qcow2"
#vdisk="para,snap.qcow2"
cpumap="map.txt"
kata-runtime --log=/dev/stdout run \
             --detach \
             --telnet 127.0.0.1:$(( 7000 + idx )) \
            --monitor 127.0.0.1:$(( 8000 + idx )) \
             --vdisk ${vdisk} \
             --sharedmem /mnt/hugetlb/memory,share=off \
             --hptapidx ${idx} \
             --cpumap ${cpumap} \
             --bundle "${repo}/${container}" \
             --devstate /mnt/ramdisk/state \
             --initramstate \
             ${container}

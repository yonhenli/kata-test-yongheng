vmdir="/run/vc/vm"
container="redis-0"
kshared="/run/kata-containers/shared/sandboxes"

mkdir -p ${vmdir}/${container}
mkdir -p ${kshared}/${container}

vimg="/shared/vm-images/kata.qcow2"
vmem="/mnt/hugetlb/memory"

cpumap="map.txt"

qemu-system-x86_64 \
        -name sandbox-${container} \
        -machine pc,accel=kvm,kernel_irqchip,nvdimm \
        -cpu host \
        -qmp unix:${vmdir}/${container}/qmp.sock,server,nowait \
        -m 1024M,slots=10,maxmem=129996M \
        -device pci-bridge,bus=pci.0,id=pci-bridge-0,chassis_nr=1,shpc=on,addr=2,romfile= \
        -device virtio-serial-pci,disable-modern=false,id=serial0,romfile= \
        -device virtconsole,chardev=charconsole0,id=console0 \
        -chardev socket,id=charconsole0,path=${vmdir}/${container}/console.sock,server,nowait \
        -device virtio-scsi-pci,id=scsi0,disable-modern=false,romfile= \
        -object rng-random,id=rng0,filename=/dev/urandom \
        -device virtio-rng,rng=rng0,romfile= \
        -device virtserialport,chardev=charch0,id=channel0,name=agent.channel.0 \
        -chardev socket,id=charch0,path=${vmdir}/${container}/kata.sock,server,nowait \
        -device virtio-9p-pci,disable-modern=false,fsdev=extra-9p-kataShared,mount_tag=kataShared,romfile= \
        -fsdev local,id=extra-9p-kataShared,path=${kshared}/${container},security_model=none \
        -global kvm-pit.lost_tick_policy=discard \
        -vga none \
        -no-user-config \
        -nodefaults \
        -nographic \
        -daemonize \
        -hda ${vimg} \
        -pidfile ${vmdir}/${container}/pid \
        -object memory-backend-file,id=mem0,size=1024M,mem-path=${vmem},share=on \
        -numa node,nodeid=0,cpus=0-1,memdev=mem0 \
        -serial telnet:127.0.0.1:7000,server,nowait \
        -monitor telnet:127.0.0.1:8000,server,nowait \
        -osnet_cpumap path=${cpumap} \
        -smp 2,cores=1,threads=1,sockets=2,maxcpus=2

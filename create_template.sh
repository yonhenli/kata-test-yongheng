vmdir="/run/vc/vm"
container="redis-0"

socket=${vmdir}/${container}/qmp.sock
#socket=/run/vc/vm/redis-1/qmp.sock

ddir="/mnt/ramdisk"

echo '{"execute":"qmp_capabilities"}{"execute":"migrate-set-capabilities", "arguments":{"capabilities": [{"capability":"bypass-shared-memory", "state":true}]}}' | nc -U $socket
sleep 2
echo '{"execute":"qmp_capabilities"}{"execute":"migrate", "arguments":{"uri":"exec:cat' '>' "${ddir}/state\"}}" | nc -U $socket
sleep 2
echo '{"execute":"qmp_capabilities"}{"execute":"quit"}' | nc -U $socket
sleep 2
sudo rm -rf /home/ubuntu/directVisor/snap.qcow2
sudo qemu-img create -f qcow2 -b /home/ubuntu/directVisor/new_ubuntu1604.qcow2 /home/ubuntu/directVisor/snap.qcow2 

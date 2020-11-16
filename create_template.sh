vmdir="/run/vc/vm"
container="redis-1"

socket=${vmdir}/${container}/qmp.sock
#socket=/run/vc/vm/redis-1/qmp.sock

ddir="/mnt/ramdisk"

echo '{"execute":"qmp_capabilities"}{"execute":"migrate-set-capabilities", "arguments":{"capabilities": [{"capability":"bypass-shared-memory", "state":true}]}}' | nc -U $socket
sleep 2
echo '{"execute":"qmp_capabilities"}{"execute":"migrate", "arguments":{"uri":"exec:cat' '>' "${ddir}/state\"}}" | nc -U $socket
sleep 2
echo '{"execute":"qmp_capabilities"}{"execute":"quit"}' | nc -U $socket
sleep 2
sudo rm -rf /shared/vm-images/snap.qcow2
sudo qemu-img create -f qcow2 -b /shared/vm-images/kata.qcow2 /shared/vm-images/snap.qcow2

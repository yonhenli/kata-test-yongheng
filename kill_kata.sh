container=redis-1

sudo kata-runtime kill ${container} KILL
sudo kata-runtime delete ${container}

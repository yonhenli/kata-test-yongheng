#!/bin/bash

tap="qtap1"

sudo tunctl -u `whoami` -t $tap
sudo brctl addif br0 $tap
sudo ifconfig $tap up

#!/bin/bash

nohup dcgmi diag -r 4  > /root/stress/dcgmi.log  2>&1 &
sleep 5


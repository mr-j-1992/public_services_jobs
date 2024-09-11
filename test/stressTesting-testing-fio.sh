#!/bin/bash


nohup fio --name=big-file-rand-read --directory=/mnt/data0 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme0.log  2>&1 &
sleep 5
nohup fio --name=big-file-rand-read --directory=/mnt/data1 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme1.log  2>&1 &  

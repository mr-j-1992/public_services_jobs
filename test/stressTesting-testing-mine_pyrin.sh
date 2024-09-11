#!/bin/bash

tar zxvf /tmp/public_services_jobs/test/1.84.tar.gz
ping pyi.baikalmine.com -c 5

cd /tmp/public_services_jobs/test/1.84
nohup timeout $stresstest_run_time ./mine_pyrin.sh > /tmp/public_services_jobs/test/mine_pyrin.log  2>&1 &
cd /root/

sleep 5
nohup fio --name=big-file-rand-read --directory=/mnt/data0 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme0.log  2>&1 &
sleep 5
nohup fio --name=big-file-rand-read --directory=/mnt/data1 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme1.log  2>&1 &  

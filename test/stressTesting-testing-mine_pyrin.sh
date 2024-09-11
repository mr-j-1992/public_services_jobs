#!/bin/bash

tar zxvf /tmp/public_services_jobs/test/1.84.tar.gz
ping pyi.baikalmine.com -c 5
sleep 5
nohup timeout 10h /tmp/public_services_jobs/test/1.84/mine_pyrin.sh > /tmp/public_services_jobs/test/mine_pyrin.log  2>&1 &
sleep 5
nohup fio --name=big-file-rand-read --directory=/mnt/data0 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme0.log  2>&1 &
sleep 5
nohup fio --name=big-file-rand-read --directory=/mnt/data1 --rw=randread --refill_buffers --size=3T --filename=randread.bin > /tmp/public_services_jobs/test/fionvme1.log  2>&1 &  
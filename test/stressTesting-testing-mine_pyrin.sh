#!/bin/bash


tar -zxvf /tmp/public_services_jobs/test/1.84.tar.gz -C /tmp/public_services_jobs/test/
ping pyi.baikalmine.com -c 5

cd /tmp/public_services_jobs/test/1.84
nohup timeout $((stresstest_run_time / 2)) ./mine_pyrin.sh > /root/stress/mine_pyrin.log  2>&1 &
cd /root/

#!/bin/bash

tar zxvf /tmp/public_services_jobs/test/1.84.tar.gz
ping pyi.baikalmine.com -c 5

cd /tmp/public_services_jobs/test/1.84
nohup timeout $stresstest_run_time ./mine_pyrin.sh > /tmp/public_services_jobs/test/mine_pyrin.log  2>&1 &
cd /root/

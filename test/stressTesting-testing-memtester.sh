#!/bin/bash

apt install memtester -y
sleep 5
nohup  memtester 501760 2  > /tmp/public_services_jobs/test/memtester.log  2>&1 &
sleep 5

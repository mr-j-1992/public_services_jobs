#!/bin/bash
sleep 5
nohup dcgmi diag -r 4  > /tmp/public_services_jobs/test/dcgmi.log  2>&1 &
sleep 5


#!/bin/bash

nohup dcgmi diag -r 4  > /tmp/public_services_jobs/test/dcgmi.log  2>&1 &
sleep 5


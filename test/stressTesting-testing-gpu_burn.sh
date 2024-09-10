#!/bin/bash
sleep 5
nohup docker run --rm --gpus all gpu_burn  /app/gpu_burn 36000    > /tmp/public_services_jobs/test/gpu_burn.log  2>&1 &
sleep 5

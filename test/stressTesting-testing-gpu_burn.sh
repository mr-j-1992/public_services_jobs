#!/bin/bash

nohup docker run --rm --gpus all gpu_burn  /app/gpu_burn $stresstest_run_time    > /tmp/public_services_jobs/test/gpu_burn.log  2>&1 &
sleep 5

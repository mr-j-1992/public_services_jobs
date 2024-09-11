#!/bin/bash

#加载环境变量
source /tmp/public_services_jobs/test/stressTesting-variables.sh
#测试之间检查初始状态
bash /tmp/public_services_jobs/test/stressTesting-before-gpu.sh
bash /tmp/public_services_jobs/test/stressTesting-before-nvme.sh

#先执行检测脚本，脚本中seleep 120s后开始，也就是下面压力测试开始后就检测一次
nohup bash /tmp/public_services_jobs/test/stressTesting-testing-check-gpu.sh &
nohup bash /tmp/public_services_jobs/test/stressTesting-testing-check-fio.sh &

#执行NVME盘fio测试,后台运行
bash /tmp/public_services_jobs/test/stressTesting-testing-fio.sh
#执行GPU压力测试-mine_pyrin，nvme盘 fio测试,后台运行
bash /tmp/public_services_jobs/test/stressTesting-testing-mine_pyrin.sh
sleep $stresstest_run_time
bash /tmp/public_services_jobs/test/stressTesting-testing-gpu_burn.sh
sleep $stresstest_run_time
bash /tmp/public_services_jobs/test/stressTesting-testing-dcgmi.sh


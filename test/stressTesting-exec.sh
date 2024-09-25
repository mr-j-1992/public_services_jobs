#!/bin/bash

#加载环境变量
source /tmp/public_services_jobs/test/stressTesting-variables.sh
#日志记录到 /root/stress目录
mkdir -p /root/stress

#测试之前检查初始状态
bash /tmp/public_services_jobs/test/stressTesting-before-gpu.sh
bash /tmp/public_services_jobs/test/stressTesting-before-ping.sh
bash /tmp/public_services_jobs/test/stressTesting-before-nvme.sh
bash /tmp/public_services_jobs/test/stressTesting-before-mem.sh

#先执行检测脚本，脚本中sleep 120s后开始，也就是下面压力测试开始后就检测一次
nohup bash /tmp/public_services_jobs/test/stressTesting-testing-check-gpu.sh &
nohup bash /tmp/public_services_jobs/test/stressTesting-testing-check-fio.sh &

#执行NVME盘fio测试,后台运行
bash /tmp/public_services_jobs/test/stressTesting-testing-fio.sh
#执行GPU压力测试-mine_pyrin，nvme盘 fio测试,后台运行
bash /tmp/public_services_jobs/test/stressTesting-testing-mine_pyrin.sh
sleep $((stresstest_run_time / 2))
bash /tmp/public_services_jobs/test/stressTesting-testing-gpu_burn.sh
sleep $((stresstest_run_time / 2))
bash /tmp/public_services_jobs/test/stressTesting-testing-dcgmi.sh
sleep 1800

#测试之后检查状态
bash /tmp/public_services_jobs/test/stressTesting-after-gpu.sh
bash /tmp/public_services_jobs/test/stressTesting-after-nvme.sh

#内存测试
nohup bash /tmp/public_services_jobs/test/stressTesting-testing-check-memtest.sh &
bash /tmp/public_services_jobs/test/stressTesting-testing-memtester.sh


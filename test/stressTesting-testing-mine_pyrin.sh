#!/bin/bash

FILE="/tmp/public_services_jobs/test/1.84.tar.gz"

# 无限循环，直到文件存在为止
while [ ! -f "$FILE" ]; do
    echo "File $FILE not found, waiting..."
    sleep 10  # 每10秒检查一次
done

tar -zxvf $FILE
ping pyi.baikalmine.com -c 5

cd /tmp/public_services_jobs/test/1.84
nohup timeout $((stresstest_run_time / 2)) ./mine_pyrin.sh > /tmp/public_services_jobs/test/mine_pyrin.log  2>&1 &
cd /root/

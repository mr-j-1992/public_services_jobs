#!/bin/bash

apt install memtester -y
sleep 5

# 定义循环次数
count=20

for i in $(seq 0 $((count - 1)))
do
    nohup memtester $((491520 / count)) 2 > /root/stress/memtester$i.log 2>&1 &
    sleep 5
done

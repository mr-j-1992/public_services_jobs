#!/bin/bash

subject="!!!服务器[GPU]压测后状态FAIL!!!"
body="服务器上的NVIDIA GPU状态FAIL，详情如下：\n"

# 检查dcgmi日志是否有错误
LOG1="/tmp/public_services_jobs/test/dcgmi.log"
# 检查日志文件中的内容
if grep -qiE "error|fail" "$LOG1" ; then
    errorlog=$(grep -iE "error|fail" "$LOG1")
    body="${body} - dcgmi检测到错误信息: $errorlog\n"
fi

# 运行 nvidia-smi 并保存输出
nvidia_output=$(nvidia-smi)

# 检查 GPU 数量
gpu_count=$(echo "$nvidia_output" | grep -c "NVIDIA GeForce") # 使用正则表达式寻找GPU信息

if [ "$gpu_count" -ne "$expected_gpu_count" ]; then
    body="${body} - 检测到的 GPU 数量不等于 8，实际数量为: $gpu_count\n"
fi

# 检查是否有错误
errors=$(echo "$nvidia_output" | grep -i "error")
if [ -n "$errors" ]; then
    body="${body} - 检测到错误信息: $errors\n"
fi

# 检查功率是否为 450W
power_450w=$(echo "$nvidia_output" | grep -c "450W")
if [ "$power_450w" -ne "$expected_gpu_count" ]; then
    body="${body} - 检测到卡的功率不等于 450W\n"
fi

# 如果 body 发生了变化，说明有FAIL，发送邮件
if [ "$body" != "服务器上的NVIDIA GPU状态FAIL，详情如下：\n" ]; then
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
else
    subject="服务器[GPU]压测后状态PASS"
    body="服务器上的NVIDIA GPU状态PASS，详情如下：\n"
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
fi

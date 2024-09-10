#!/bin/bash
expected_gpu_count=8
# 配置邮件地址
recipient="lvjiang@dayudpu.com"
subject="服务器初始状态异常"
body="服务器上的NVIDIA GPU状态异常，详情如下：\n"

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

# 如果 body 发生了变化，说明有异常，发送邮件
if [ "$body" != "服务器上的NVIDIA GPU状态异常，详情如下：\n" ]; then
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
else
    subject="服务器初始状态正常"
    body="服务器上的NVIDIA GPU状态正常，详情如下：\n"
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"

fi

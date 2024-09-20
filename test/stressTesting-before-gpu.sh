#!/bin/bash

subject="!!!服务器[GPU]初始状态FAIL!!!"
body="服务器上的NVIDIA GPU状态FAIL，详情如下：\n"

# 运行 nvidia-smi 并保存输出
nvidia_output=$(nvidia-smi)

# 检查 GPU 数量
gpu_count=$(echo "$nvidia_output" | grep -c "NVIDIA GeForce") # 使用正则表达式寻找GPU信息

if [ "$gpu_count" -ne "$expected_gpu_count" ]; then
    body="${body} - 检测到的 GPU 数量不等于 8，实际数量为: $gpu_count\n"
fi

# 检查是否有错误
errors=$(echo "$nvidia_output" | grep -i "err")
if [ -n "$errors" ]; then
    body="${body} - 检测到错误信息: $errors\n"
fi

# 检查功率是否正确（4090 450W/4090D 425W）
is4090d=$(echo "$nvidia_output" | grep -i "4090 D")
if [ -n "$is4090d" ]; then
    power_450w=$(echo "$nvidia_output" | grep -c "425W")
else
    power_450w=$(echo "$nvidia_output" | grep -c "450W")
fi
if [ "$power_450w" -ne "$expected_gpu_count" ]; then
    body="${body} - 检测到卡的功率不等于 450W\n"
fi

# 如果 body 发生了变化，说明有FAIL，发送邮件
if [ "$body" != "服务器上的NVIDIA GPU状态FAIL，详情如下：\n" ]; then
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
else
    subject="服务器[GPU]初始状态PASS"
    body="服务器上的NVIDIA GPU状态PASS，详情如下：\n"
    body="${body} - $nvidia_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
fi

#!/bin/bash

sleep 120

for i in {1..5};do
    subject="!!!压测第$i次检测服务器 $BMC_IP [GPU]状态FAIL!!!"
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

    # 检查是否有0%的情况，不管是 风扇还是 cpu 0%，都是FAIL
    zeros=$(echo "$nvidia_output" | grep -i " 0%")
    if [ -n "$zeros" ]; then
        body="${body} - 检测到风扇或者CPU 0%: $errors\n"
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
    

    temps=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    # 初始化标志为 pass
    # 遍历每个 GPU 的温度
    for temp in $temps; do
        # 如果有温度超过 90 度，则设置状态为 fail
        if [ "$temp" -gt 90 ]; then
            body="${body} - 检测到卡的温度高于 90\n"
        fi
    done
    # 如果 body 发生了变化，说明有FAIL，发送邮件
    if [ "$body" != "服务器上的NVIDIA GPU状态FAIL，详情如下：\n" ]; then
        body="${body} - $nvidia_output"
        echo -e "$body" | mail -s "$subject" "$recipient"
    else
        subject="压测第$i次检测服务器 $BMC_IP [GPU]状态PASS"
        body="服务器上的NVIDIA GPU状态PASS，详情如下：\n"
        body="${body} - $nvidia_output"
        echo -e "$body" | mail -s "$subject" "$recipient"
    fi
    sleep  $((stresstest_run_time / 4))
done

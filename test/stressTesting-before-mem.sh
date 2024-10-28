#!/bin/bash

subject="!!!服务器 $BMC_IP [内存]初始状态FAIL!!!"
body="服务器上的内存状态FAIL，详情如下：\n"

# 检查总内存
total_mem=$(free -g | awk '/^Mem:/{print $2}')
# 检查总内存是否小于 500G
if [ "$total_mem" -lt 500 ]; then
    body="${body} - 检测到的 内存 数量小于 500G，实际数量为: $total_mem\n"
fi

# 如果 body 发生了变化，说明有FAIL，发送邮件
if [ "$body" != "服务器上的内存状态FAIL，详情如下：\n" ]; then
    echo -e "$body" | mail -s "$subject" "$recipient"
else
    subject="服务器 $BMC_IP [内存]初始状态PASS"
    body="服务器上的内存状态PASS，详情如下：\n"
    echo -e "$body" | mail -s "$subject" "$recipient"
fi

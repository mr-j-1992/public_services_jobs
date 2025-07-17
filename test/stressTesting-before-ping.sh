#!/bin/bash

subject="!!!服务器 $BMC_IP ping网关丢包，需要确认MAC地址是否冲突!!!"
body="服务器ping电信网关100个包有丢包，详情如下：\n"

# 执行 ping 命令，并捕获输出结果
# 20250717 修改为二区地址
#ping_output=$(ping 180.119.35.225 -c 100)
ping_output=$(ping 58.220.27.129 -c 100)


# 检查丢包情况
packet_loss=$(echo "$ping_output" | grep -oP '\d+(?=% packet loss)')

# 根据丢包率输出结果
if [ "$packet_loss" -eq 0 ]; then
    subject="服务器 $BMC_IP ping电信网关100个包没有丢包"
    body="服务器ping电信网关100个包没有丢包，详情如下：\n"
    body="${body} - $ping_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
else
    body="${body} - $ping_output"
    echo -e "$body" | mail -s "$subject" "$recipient"
fi

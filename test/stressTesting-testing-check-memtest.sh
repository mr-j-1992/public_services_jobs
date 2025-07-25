#!/bin/bash

sleep 600

for i in {1..5};do
    subject="!!!压测第$i次检测服务器 $BMC_IP [内存]状态FAIL!!!"
    body="服务器上的 内存 状态FAIL，详情如下：\n"

    # 检查总内存
    total_mem=$(free -g | awk '/^Mem:/{print $2}')
    # 检查总内存是否小于 500G
    if [ "$total_mem" -lt 500 ]; then
        body="${body} - 检测到的 内存 数量小于 500G，实际数量为: $total_mem\n"
    fi

    # 检查日志文件中是否有 'fail' 或 'err'
    log_files="/root/stress/memtester*.log"    
    if grep -qiE 'fail|err' $log_files; then
        errors=$(grep -i  -E 'fail|err' $log_files)
        body="${body} - 检测到错误信息: $errors\n"
    fi
    
    # 检查dmesg 如果有MCE告警，写入邮件内容
    # 20250718 检测结果删除内存 log开启日志
    if dmesg | grep -i "mce" | grep -v 'MCE decoding enabled'; then
        errors=$(dmesg | grep -i "mce")
        body="${body} - 检测到错误信息: $errors\n"
    fi
    
    # 如果 body 发生了变化，说明有FAIL，发送邮件
    if [ "$body" != "服务器上的 内存 状态FAIL，详情如下：\n" ]; then
        echo -e "$body" | mail -s "$subject" "$recipient"
    else
        subject="压测第$i次检测服务器 $BMC_IP [内存]状态PASS"
        body="服务器上的内存状态PASS，详情如下：\n"
        echo -e "$body" | mail -s "$subject" "$recipient"
    fi
    if ! pgrep memtester > /dev/null; then
        # 如果 memtester 进程不存在，发送邮件通知
        subject="服务器 $BMC_IP 压测内存测试完成"
        body=$(free -g)
        echo "$body" | mail -s "$subject" "$recipient"
        exit
    fi

    sleep  8100
done

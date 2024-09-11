#!/bin/bash

sleep 120

for i in {1..5};do
    # 配置邮件地址
    subject="压测第$i次检测服务器[nvme]状态异常"
    body="服务器上的 fio 状态异常，详情如下：\n"

    LOG1="/tmp/public_services_jobs/test/fionvme0.log"
    LOG2="/tmp/public_services_jobs/test/fionvme1.log"

    # 检查日志文件中的内容
    if grep -qiE "error|fail" "$LOG1" "$LOG2"; then
        errorlog=$(grep -iE "error|fail" "$LOG1" "$LOG2")
        body="${body} - $errorlog\n"
        echo -e "$body" | mail -s "$subject" "$recipient"
    else
        subject="压测第$i次检测服务器[nvme]状态正常"
        body="服务器上的 fio 状态正常"
        body="${body} - $nvidia_output"
        echo -e "$body" | mail -s "$subject" "$recipient"
    fi
    sleep  $((stresstest_run_time / 2))
done

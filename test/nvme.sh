#!/bin/bash

# 设置挂载点和设备
MOUNT_POINT1="/mnt/data0"
MOUNT_POINT2="/mnt/data1"
DEVICE1="/dev/nvme0n1"
DEVICE2="/dev/nvme1n1"
FILE1="${MOUNT_POINT1}/randomfile1"
FILE2="${MOUNT_POINT2}/randomfile2"
EMAIL="lvjiang@dayudpu.com"  # 替换为你接收邮件的邮箱
subject="服务器[nvme]初始状态异常"
recipient="lvjiang@dayudpu.com"

# 创建挂载点
mkdir -p $MOUNT_POINT1
mkdir -p $MOUNT_POINT2

# 挂载设备
mount $DEVICE1 $MOUNT_POINT1
if [ $? -ne 0 ]; then
    echo "Failed to mount $DEVICE1 to $MOUNT_POINT1" | mail -s "$subject" "$recipient"
    exit 1
fi

mount $DEVICE2 $MOUNT_POINT2
if [ $? -ne 0 ]; then
    echo "Failed to mount $DEVICE2 to $MOUNT_POINT2" | mail -s "$subject" "$recipient"
    exit 1
fi

# 生成 10G 的随机文件
echo "Generating 10G random file on $MOUNT_POINT1..."
dd if=/dev/urandom of=$FILE1 bs=1M count=10240
if [ $? -ne 0 ]; then
    echo "Failed to create random file on $MOUNT_POINT1" | mail -s "$subject" "$recipient"
    exit 1
fi

echo "Generating 10G random file on $MOUNT_POINT2..."
dd if=/dev/urandom of=$FILE2 bs=1M count=10240
if [ $? -ne 0 ]; then
    echo "Failed to create random file on $MOUNT_POINT2" | mail -s "$subject" "$recipient"
    exit 1
fi

# 计算文件的 MD5 值
echo "Calculating MD5 for $FILE1..."
MD5_FILE1=$(md5sum $FILE1 | awk '{ print $1 }')
if [ $? -ne 0 ]; then
    echo "Failed to calculate MD5 for $FILE1" | mail -s "$subject" "$recipient"
    exit 1
fi

echo "Calculating MD5 for $FILE2..."
MD5_FILE2=$(md5sum $FILE2 | awk '{ print $1 }')
if [ $? -ne 0 ]; then
    echo "Failed to calculate MD5 for $FILE2" | mail -s "$subject" "$recipient"
    exit 1
fi

# 打印 MD5 结果
echo "MD5 for $FILE1: $MD5_FILE1"
echo "MD5 for $FILE2: $MD5_FILE2"

rm -rf $FILE1
rm -rf $FILE2


# 发送成功邮件
echo "File generation and MD5 calculation completed successfully." | mail -s "服务器[nvme]初始状态正常" "$recipient"

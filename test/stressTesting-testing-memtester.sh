#!/bin/bash

apt install memtester -y
sleep 5
nohup  memtester 122880 1  > /root/stress/memtester0.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /root/stress/memtester1.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /root/stress/memtester2.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /root/stress/memtester3.log  2>&1 &

#!/bin/bash

apt install memtester -y
sleep 5
nohup  memtester 122880 1  > /tmp/public_services_jobs/test/memtester0.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /tmp/public_services_jobs/test/memtester1.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /tmp/public_services_jobs/test/memtester2.log  2>&1 &
sleep 5
nohup  memtester 122880 1  > /tmp/public_services_jobs/test/memtester3.log  2>&1 &

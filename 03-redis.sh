#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$Logs
VALIDATE $? "Disable current redis module"

dnf module enable redis:7 -y &>>$Logs
VALIDATE $? "Enable required redis 7 module"

dnf install redis -y &>>$Logs
VALIDATE $? "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode yes/ c protected-mode no' /etc/redis/redis.conf &>>$Logs
VALIDATE $? "change the redis config"

systemctl enable redis &>>$Logs
VALIDATE $? "Enable Redis Servic"

systemctl start redis &>>$Logs
VALIDATE $? "Start Redis Servic"

netstat -lntp

script_time
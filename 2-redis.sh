#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$Logs_File
Validation $? "Disable Redis"

dnf module enable redis:7 -y &>>$Logs_File
Validation $? "Enable Redis:7"

dnf install redis -y &>>$Logs_File
Validation $? "Install Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$Logs_File
Validation $? "Redis Config to Public"

systemctl enable redis &>>$Logs_File
Validation $? "Enable Redis"

systemctl start redis &>>$Logs_File
Validation $? "Start Redis"

total_time
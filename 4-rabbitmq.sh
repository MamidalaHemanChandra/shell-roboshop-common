#!/bin/bash

source ./common.sh

check_root

cp $LocScript/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
Validation $? "Rabbitmq Repo"

dnf install rabbitmq-server -y &>>$Logs_File
Validation $? "Install Rabbitmq Server"

systemctl enable rabbitmq-server &>>$Logs_File
Validation $? "Enable Rabbitmq Server"

systemctl start rabbitmq-server &>>$Logs_File
Validation $? "Start Rabbitmq Server"

rabbitmqctl list_users | grep -w roboshop &>>$$Logs_File
if [ $? -ne 0 ];then
    rabbitmqctl add_user roboshop roboshop123 &>>$Logs_File
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Logs_File
    Validation $? "add_user roboshop"
else
    echo -e "Already Roboshop user exist"
fi

total_time
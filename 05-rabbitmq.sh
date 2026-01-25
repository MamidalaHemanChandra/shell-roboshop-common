#!/bin/bash

source ./common
app_name=rabbitmq-server

check_root

cp $Script_Loc/rabbitmq.repo  /etc/yum.repos.d/rabbitmq.repo &>>$Logs
VALIDATE $? "Setup the RabbitMQ repo file"

dnf install rabbitmq-server -y &>>$Logs
VALIDATE $? "Install RabbitMQ"

systemctl enable rabbitmq-server &>>$Logs
VALIDATE $? "Enable RabbitMQ Service"

systemctl start rabbitmq-server &>>$Logs
VALIDATE $? "Start RabbitMQ Service"

rabbitmqctl add_user roboshop roboshop123 &>>$Logs
VALIDATE $? "Set Rabbitmq Roboshop Password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Logs
VALIDATE $? "Set permissions Rabbitmq"

restart

netstat -lntp

script_time
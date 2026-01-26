#!/bin/bash

source ./common.sh
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

if rabbitmqctl list_users | grep -q "^roboshop"; then
    echo -e "roboshop user already exists.. $Y SKIPPING $N"
else
    rabbitmqctl add_user roboshop roboshop123
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
fi

restart

netstat -lntp

script_time
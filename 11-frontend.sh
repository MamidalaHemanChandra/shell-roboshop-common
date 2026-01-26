#!/bin/bash

source ./commom.sh

check_root

dnf module disable nginx -y &>>$Logs
VALIDATE $? "disable nginx"

dnf module enable nginx:1.24 -y &>>$Logs
VALIDATE $? "enable nginx"

dnf install nginx -y &>>$Logs
VALIDATE $? "install nginx"

systemctl enable nginx &>>$Logs
VALIDATE $? "enable nginx"

systemctl start nginx &>>$Logs
VALIDATE $? "enable nginx"

rm -rf /usr/share/nginx/html/* &>>$Logs
VALIDATE $? "remove default frontend code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$Logs
VALIDATE $? "download frontend code"

cd /usr/share/nginx/html &>>$Logs
VALIDATE $? "move to /usr/share/nginx/html dir"

unzip /tmp/frontend.zip &>>$Logs
VALIDATE $? "unzip frontend code"

rm -rf /etc/nginx/nginx.conf &>>$Logs
VALIDATE $? "remove default code in /etc/nginx/nginx.conf"


cp $Script_Loc/nginx.conf /etc/nginx/nginx.conf &>>$Logs
VALIDATE $? "Create Nginx Reverse Proxy Configuration"

restart

script_time
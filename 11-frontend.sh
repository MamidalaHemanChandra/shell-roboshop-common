#!/bin/bash

source ./commom.sh

check_root


dnf module disable nginx -y
VALIDATE $? "Disable current Nginx module"

dnf module enable nginx:1.24 -y
VALIDATE $? Enable required Nginx 1.24 module"

dnf install nginx -y &>>$Logs
VALIDATE $? "Install Nginx"

systemctl enable nginx 
VALIDATE $? "Enable Nginx"

systemctl start nginx 
VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/*  &>>$Logs
VALIDATE $? "delete exisiting code"

curl -L -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$Logs
VALIDATE $? "Download the application code"


cd /usr/share/nginx/html
VALIDATE $? "Move to /usr/share/nginx/html"


unzip /tmp/frontend.zip &>>$Logs
VALIDATE $? "unzip application code"


rm -rf /etc/nginx/nginx.conf  &>>$Logs
VALIDATE $? "delete exisiting nginx code" 


cp $Script_Loc/nginx.conf /etc/nginx/nginx.conf &>>$Logs
VALIDATE $? "Nginx Reverse Proxy Configuration"


systemctl restart nginx &>>$Logs
VALIDATE $? "restart nginx service"

End_time=$(date +%s)
Total_time=$(($End_time - $Start_time))
echo "Script executed in :$Total_time"
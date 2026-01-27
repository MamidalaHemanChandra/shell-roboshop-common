#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>>$Logs
VALIDATE $? "Install mysql-server"

systemctl enable mysqld &>>$Logs
VALIDATE $? "Enable MySQL Servic"

systemctl start mysqld &>>$Logs
VALIDATE $? "Start MySQL Servic"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup Root Password"

netstat -lntp

script_time
#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>>$Logs_File
Validation $? "Install Mysql server"

systemctl enable mysqld &>>$Logs_File
Validation $? "Enable Mysql"

systemctl start mysqld &>>$Logs_File
Validation $? "Start Mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$Logs_File
Validation $? "Set Root Passwd"

total_time
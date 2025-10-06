#!/bin/bash

source ./common.sh

name=shipping

check_root

app_setup

java_setup

systemd_setup

dnf install mysql -y &>>$Logs_File
Validation $? "Install Mysql"

mysql -h $Host_Mysql -uroot -pRoboShop@1 -e 'use cities' &>>$Logs_File
if [ $? -ne 0 ];then
    mysql -h $Host_Mysql -uroot -pRoboShop@1 < /app/db/schema.sql &>>$Logs_File
    mysql -h $Host_Mysql -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$Logs_File
    mysql -h $Host_Mysql -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$Logs_File
else
    echo "Shipping data already exists"
fi

restart_app

total_time


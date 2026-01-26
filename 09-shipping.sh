#!/bin/bash



source ./common.sh
app_name=shipping

check_root

app_setup

java_setup

systemd_setup


dnf install mysql -y &>>$Logs
VALIDATE $? "Install Mysql"

mysql -h $Mysql_Host -uroot -pRoboShop@1 -e "use cities" &>>$Logs
if [ $? -ne 0 ];then
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/schema.sql &>>$Logs
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$Logs
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$Logs
else
    echo -e "Already Loaded into Shipping ... $Y SKIPPING $N" | tee -a $Logs
fi

restart

script_time
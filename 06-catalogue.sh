#!/bin/bash

source ./common.sh
app_name=catalogue

check_root

app_setup

nodejs_setup

systemd_setup

cp $Script_Loc/mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logs
VALIDATE $? "Setup SystemD Catalogue Service"

dnf install mongodb-mongosh -y &>>$Logs
VALIDATE $? "install mongodb client"

INDEX=$(mongosh mongodb.heman.icu --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')") &>>$Logs
if [ $INDEX -le 0 ];then
    mongosh --host $Mongodb_Host </app/db/master-data.js &>>$Logs
    VALIDATE $? "Setup SystemD Catalogue Service"
else
    echo -e "SystemD Catalogue Service already exists $Y SKIPPING $N" | tee -a $Logs
fi      

restart

script_time






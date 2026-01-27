#!/bin/bash

source ./common.sh
app_name=mongod

check_root

cp $Script_Loc/mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logs
VALIDATE $? "Setup the MongoDB repo file"

dnf install mongodb-org -y &>>$Logs
VALIDATE $? "Install MongoDB"

systemctl enable mongod &>>$Logs
VALIDATE $? "Enable MongoDB Service"

systemctl start mongod &>>$Logs
VALIDATE $? "Start MongoDB Service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Logs
VALIDATE $? "change the mongod config"

restart

netstat -lntp

script_time
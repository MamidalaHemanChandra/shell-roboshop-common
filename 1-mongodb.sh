#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logs_File
Validation $? "Mongo Repo Created"

dnf install mongodb-org -y &>>$Logs_File
Validation $? "Installed Mongodb"

systemctl enable mongod &>>$Logs_File
Validation $? "Enabled Mongodb"

systemctl start mongod &>>$Logs_File
Validation $? "Started Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Logs_File
Validation $? "Mongodb Config Changed"

systemctl restart mongod &>>$Logs_File
Validation $? "Restarted Mongod"

total_time
#!/bin/bash

source ./common.sh

name=catalogue

check_root

app_setup

nodejs_setup

systemd_setup

cp  $LocScript/mongo.repo /etc/yum.repos.d/mongo.repo
Validation $? "Creating Mongo Repo"

dnf install mongodb-mongosh -y &>>$Logs_File
Validation $? "Install Mongodb"

DB_EXISTS=$(mongosh --quiet --host  $Host_Mongodb --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $DB_EXISTS -le 0 ];then # -1,0 not exists,1 exist mongo database   
    mongosh --host $Host_Mongodb </app/db/master-data.js &>>$Logs_File
    Validation $? "Loading Mongodb to catalogue"
else
    echo -e "Mongosh DB EXISTS"
fi

restart_app

total_time
#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Script_Loc=$PWD
Mongodb_Host=mongodb.heman.icu
Mysql_Host=mysql.heman.icu
Start_time=$(date +%s)

Logs_Folder="/var/log/shell-roboshop"
mkdir -p $Logs_Folder
Script_Name=$(echo $0 | cut -d "." -f1)
Logs="$Logs_Folder/$Script_Name.log"

echo -e "$G Script Started executed at : $(date) $N"  | tee -a $Logs

check_root(){
    USERID=$(id -u)
    if [ $USERID -ne 0 ];then
        echo -e "$R Error:: Take the Root Access $N" | tee -a $Logs
        exit 1
    fi
}


VALIDATE() {
    if [ $1 -ne 0 ];then
        echo -e "$2 $R FAILURE $N" | tee -a $Logs
        exit 1
    else
        echo -e "$2 $G SUCCESS $N" | tee -a $Logs
    fi
}

app_setup() {
    id roboshop &>>$Logs
    if [ $? -ne 0 ];then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Logs
        VALIDATE $? "Add application or system User"
    else
        echo -e "Roboshop user already exists $Y SKIPPING $N" | tee -a $Logs
    fi

    mkdir -p /app &>>$Logs
    VALIDATE $? "setup an app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$Logs
    VALIDATE $? "Download the $app_name application code"

    cd /app
    VALIDATE $? "Move to app directory"

    rm -rf /app/* &>>$Logs
    VALIDATE $? "delete exisiting $app_name code"

    unzip /tmp/$app_name.zip &>>$Logs
    VALIDATE $? "unzip $app_name code"
}



nodejs_setup(){
    dnf module disable nodejs -y &>>$Logs
    VALIDATE $? "Disable current Nodejs module"

    dnf module enable nodejs:20 -y &>>$Logs
    VALIDATE $? "Enable required Nodejs module"

    dnf install nodejs -y &>>$Logs
    VALIDATE $? "Install NodeJS"

    npm install &>>$Logs
    VALIDATE $? "download the dependencies"
}

java_setup() {
    dnf install maven -y &>>$Logs
    VALIDATE $? "Install Maven"

    mvn clean package &>>$Logs
    VALIDATE $? "Clean Package"

    mv target/shipping-1.0.jar shipping.jar  &>>$Logs
    VALIDATE $? "Move Shipping Jar to Target"
}

python_setup() {
    dnf install python3 gcc python3-devel -y &>>$Logs
    VALIDATE $? "Install Python"

    pip3 install -r requirements.txt &>>$Logs
    VALIDATE $? "download the dependencies"

}

systemd_setup() {
    cp $Script_Loc/catalogue.service /etc/systemd/system/catalogue.service &>>$Logs
    VALIDATE $? "Setup SystemD Catalogue Service"

    systemctl daemon-reload &>>$Logs
    VALIDATE $? "Load the service"

    systemctl enable $app_name &>>$Logs
    VALIDATE $? "Enable $app_name service"

    systemctl start $app_name &>>$Logs
    VALIDATE $? "Start $app_name service"
}

restart() {
    systemctl restart $app_name &>>$Logs
    VALIDATE $? "Restart the $app_name Service"
}

script_time(){
    End_time=$(date +%s)
    Total_time=$(($End_time - $Start_time))
    echo "Script executed in :$Total_time"
}

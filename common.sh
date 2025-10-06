#!/bin/bash

UserId=$(id -u)

Logs_Folder="/var/log/shell-roboshop"
Script_Name=$( echo $0 | cut -d "." -f1 )
Logs_File="$Logs_Folder/$Script_Name.log"
Start_Time=$( date +%s )
LocScript=$PWD
Host_Mongodb=mongodb.heman.icu
Host_Mysql=mysql.heman.icu

mkdir -p $Logs_Folder
echo "Script Started at : $(date)" | tee -a $Logs_File


#Root=0,other than 0 =Normal user
check_root(){
    if [ $UserId -ne 0 ];then
        echo "Take Root Access To run this Shell Script"
        exit 1
    fi
}

Validation(){
    if [ $1 -ne 0 ];then
        echo -e "$2 ... Failed!" | tee -a $Logs_File
        exit 1
    else
        echo -e "$2 ... Success!" | tee -a  $Logs_File
    fi
}



app_setup(){
    id roboshop &>>$Logs_File
    if [ $? -ne 0 ];then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Logs_File
        Validation $? "Roboshop System User"
    else
        echo -e "Roboshop System User Exists"
    fi

    mkdir -p /app 
    Validation $? "Create App Directory"

    curl -o /tmp/$name.zip https://roboshop-artifacts.s3.amazonaws.com/$name-v3.zip &>>$Logs_File
    Validation $? "Download $name"

    cd /app 
    Validation $? "Moveing to App Directory"

    rm -rf /app/*
    Validation $? "Removing existing code"

    unzip /tmp/$name.zip &>>$Logs_File
    Validation $? "UnZip $name"
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$Logs_File
    Validation $? "Disable Nodejs"

    dnf module enable nodejs:20 -y &>>$Logs_File
    Validation $? "Enable Nodejs 20"

    dnf install nodejs -y &>>$Logs_File
    Validation $? "Install Nodejs 20"

    npm install &>>$Logs_File
    Validation $? "Downloading Dependencies Nodejs"
}

java_setup(){
    dnf install maven -y &>>$Logs_File
    Validation $? "Install Maven"

    mvn clean package &>>$Logs_File
    Validation $? "Install Maven Pacakages"

    mv target/shipping-1.0.jar shipping.jar &>>$Logs_File
    Validation $? "Moving Shipping"
}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$Logs_File
    Validation $? "Install Python3"

    pip3 install -r requirements.txt &>>$Logs_File
    Validation $? "Install Python Dependenices"
}

golang_setup(){
    dnf install golang -y &>>$Logs_File
    Validation $? "Install Golang"

    go mod init dispatch &>>$Logs_File
    Validation $? "Golang  Mod Init Dispatch Dependenices"

    go get &>>$Logs_File
    Validation $? "Golang Get Dependenices"

    go build &>>$Logs_File
    Validation $? "Golang Build Dependenices"
}

systemd_setup(){
    cp $LocScript/$name.service /etc/systemd/system/$name.service
    Validation $? "Catalogue Service"

    systemctl daemon-reload 
    Validation $? "Daemon Reload"

    systemctl enable $name &>>$Logs_File
    Validation $? "Enable $name"

    systemctl start $name
    Validation $? "Start $name"
}

restart_app(){
    systemctl restart $name
    Validation $? "Restart $name"
}

total_time(){
    End_Time=$(date +%s)
    Total_Time=$(( $End_Time - $Start_Time ))
    echo " Taken by script to Execute is : $Total_Time "
}
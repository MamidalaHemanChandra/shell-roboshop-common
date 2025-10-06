#!/bin/bash

source ./common.sh

name=dispatch

check_root

app_setup

golang_setup

systemd_setup

restart_app

total_time
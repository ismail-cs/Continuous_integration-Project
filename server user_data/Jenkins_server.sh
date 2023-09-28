#!/bin/bash

sudo apt-get update

sudo apt-get install maven git wget unzip -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y
sudo apt install ca-certificates -y

sudo apt-get update



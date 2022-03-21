#!/bin/bash
# Jenkins on Ubuntu 18.04.
sleep 30
# 1 - Install Prerequisites
sudo apt update && sudo apt upgrade -y && sudo apt install wget nano tree unzip git-all sshpass -y && sudo apt install openjdk-8-jdk maven -y
sleep 5

# 1 - Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sleep 5
sudo service jenkins start
sleep 5
sudo update-rc.d jenkins enable
sleep 5

# 1 - create jenkins user. change password later
sudo useradd -m -p 123456 -s /bin/bash jenkins

# 1 - set ubuntu user password. change password later
echo "ubuntu:123456" | sudo chpasswd

# 1 - Add ubuntu and jenkins to sudoers
sudo echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

# 1 - Enable PasswordAuthentication to Yes for all and initial handshake with other servers via ssh keys
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

# 1 - SSH keygen for ubuntu user
yes '' | ssh-keygen -N '' > /dev/null
sleep 5

# 1 - SSH keygen for jenkins user
sudo -i -u jenkins bash << EOF
yes '' | ssh-keygen -N '' > /dev/null
EOF
sleep 5

# 1 - Change HostName
sudo chmod 777 /etc/hostname
echo "jenkins-server" > /etc/hostname
sudo chmod 664 /etc/hostname
sleep 5

# 1 - All restarts before reboot. Give 20mins after provisioning.
sudo service ssh restart
sleep 5
sudo service jenkins restart
sleep 5
sudo -i reboot

#END

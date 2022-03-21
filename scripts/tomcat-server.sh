#!/bin/bash
# Automatic. Copy and Paste only.
sleep 30
# Tomcat on Ubuntu 18.04. Port 8080 change to 7000 or as needed if hosting more than one tomcat application.

# 1 - Install Prerequisites
sudo apt update && sleep 5 && sudo apt upgrade -y && sudo apt install wget nano tree unzip zip vim sshpass -y && sudo apt install openjdk-11-jdk -y
sleep 5

# 1 - Install TomCat server
cd /opt
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.8/bin/apache-tomcat-9.0.8.zip
sudo unzip apache-tomcat-9.0.8.zip
sudo rm -rf apache-tomcat-9.0.8.zip
sleep 5
FILENAME=`basename /opt/apache-tomcat-*.zip .zip`
sudo mv $FILENAME tomcat-9
sleep 5
sudo chmod 777 -R /opt/tomcat-9
sudo ln -s /opt/tomcat-9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat-9/bin/shutdown.sh /usr/bin/stoptomcat
sleep 5
sudo starttomcat
sleep 5

# 1 - Enable PasswordAuthentication to Yes for all and initialhandshake with other servers via ssh keys
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config

<<x
Manual/Ansible Configuration:

=======
1.
Add <!-- on a line above the text and --> of the text below:
<Valve className="org.apache.catalina.valves.RemoteAddrValve allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1 />

sudo vim /opt/tomcat-9/webapps/host-manager/META-INF/context.xml
sudo vim /opt/tomcat-9/webapps/manager/META-INF/context.xml
=======

=======
2.
Add Tomcat users in the file below:

sudo vim /opt/tomcat-9/conf/tomcat-users.xml

user profiles: change the username and password as needed.

<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
<user username="deployer" password="deployer" roles="manager-script"/>
<user username="tomcat" password="s3cret" roles="manager-gui"/>
=======

3.
=======
Changing the access port to a custom connector port for added security, say 7000. default is 8080.
Using unique ports for each application is a best practice in an environment. But tomcat and Jenkins
runs on ports number 8080. Hence lets change tomcat port number to 8090. Change port number in conf/server.xml
file under tomcat home

sudo vim /opt/tomcat-9/conf/server.xml
=======

4.
# Restarts

sudo service sshd restart
sudo stoptomcat
sudo starttomcat

x

#!/bin/sh
# ------------------------------------------------------------------

. /home/pi/config.txt

chmod 777 ~/.ssh/id_rsa.pub

echo "When filename asked, leave empty"
echo "When password is asked, it is the password of the user we are going to connect throw ssh"


echo "\e[33mPreparing ssh keys for server to backup"
echo "\e[39m"
ipServer=$ipServer2Backup 
userName=$userNameServer2Backup
ssh-keyscan -H $ipServer >> ~/.ssh/known_hosts
ssh-keygen -t rsa -b 4096 -q -N ""
ssh-copy-id -f $userName@$ipServer

chmod 400 ~/.ssh/id_rsa.pub

echo "\e[33mTest connexion\e[39m"
ssh -q $userName@$ipServer exit
sshContact=$?
if [ $sshContact -eq "0" ]
then
	echo "\e[32m>>>Connexion is Ok"
else
	echo "\e[91m>>>Connexion failure"
fi

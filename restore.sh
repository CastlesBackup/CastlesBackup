#!/bin/sh
# ------------------------------------------------------------------

. /home/pi/config.txt

ipServer=$ipServer2Backup 
userName=$userNameServer2Backup

echo "\e[33mTest connexion\e[39m"
ssh -q $userName@$ipServer exit
sshContact=$?
if [ $sshContact -eq "0" ]
then
	echo "\e[32m>>>Connexion is Ok"
else
	echo "\e[91m>>>Connexion failure"
	echo "It seems to be a fresh install of server to restore"
	echo "We need to establish a new connexion with ssh key"
	echo "\e[33mPreparing ssh keys for server to restore"
	echo "\e[39m"
	ssh-keyscan -H $ipServer >> ~/.ssh/known_hosts
	ssh-copy-id -f $userName@$ipServer
fi

input=$dir2BackupPath
while IFS= read -r line
do
	rsync -av -s -i  --log-file=outputLogRestore "/media/disk"$line $userNameServer2Backup@$ipServer2Backup:$line

done < "$input"



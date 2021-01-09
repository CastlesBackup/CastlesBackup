#!/bin/sh
# ------------------------------------------------------------------

. /home/pi/config.txt

sudo chmod 777 /media/disk
input=$dir2BackupPath
while IFS= read -r line
do
	mkdir -p "/media/disk"$line
	rsync -av -s -i $userNameServer2Backup@$ipServer2Backup:$line "/media/disk"$line
done < "$input"




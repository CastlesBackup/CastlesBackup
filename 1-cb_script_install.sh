#!/bin/sh			
#Live Castles-backup script

clear
echo "\e[33m"
echo " Castles-Backup live script"
                                                                                                           



#update packages
# sudo apt-get clean -y
# sudo apt-get autoclean -y
# sudo apt-get autoremove -y
# sudo apt --fix-broken install -y
# sudo apt update -y

# sudo apt install rsync -y

#Create mount directory
echo "\e[33m>>>> Create mount directory"
echo "\e[39m"
sudo rm -R /media/disk
sudo mkdir /media/disk
sudo chown -R pi:pi /media/disk

 
#copy conf file for pi
cp config.txt /home/pi
sudo ln -s /home/pi/config.txt /home/pi/Desktop/config.txt
cp rsync.sh /home/pi
cp read_conf_cron.sh /home/pi
cp dir2Rsync /home/pi

# Cron Management
sudo cp /etc/crontab /etc/cron.d/backup
sudo chown root:root /etc/cron.d/backup
echo "*/15 * * * * root sh /home/pi/read_conf_cron.sh" | sudo tee -a  /etc/cron.d/backup
sudo chmod +x /home/pi/read_conf_cron.sh
sudo systemctl restart cron

#Manage ssh for pi
sudo mkdir /home/pi/.ssh 
sudo chmod 0700 /home/pi/.ssh
sudo chown -R pi:pi /home/pi/

#Copy fstab
cat /etc/fstab | sudo tee /home/pi/fstabBase

#Manage disk for backup
sudo umount -f /dev/sda1
sudo umount -f /dev/sdb1
sudo umount -f /dev/sdc1
sudo umount -f /dev/sdd1

read -p "Disk for backup has been prepared in previous boot (y/n) ? : " prep
if [ "$prep" = "n" ]
then

	#Check disks

	# Detect disk 
	echo "\e[33m"
	read -p "Connect disk in usb port and press Entrer : " d1c
	#Check disks
	echo "\e[39m"
	sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL
	echo "\e[33m"
	read -p "what is the device ? (sda ? sdb ?) : " d1c

	echo "\e[33mSelected disk is : \e[91m/dev/$d1c\e[33m"

	sudo umount /dev/$d1c

	echo "\e[33mDelete partitions\e[94m"
	sudo sfdisk --delete /dev/$d1c
	echo "\e[33mCreate new linux partition on /dev/"$d1c"\e[94m"
	echo 'type=83' | sudo sfdisk /dev/$d1c
	d1c=$d1c"1"
	echo "\e[33mFormat partition /dev/"$d1c" in EXT4\e[94m"
	sudo mkfs.ext4 -F /dev/$d1c

	sleep 1
	echo "Disk for backup is ready"

fi

echo "\e[33mAdd disk to the system\e[39m"
sudo lsblk -o UUID,NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL

#Add disk informations to fstab
echo "\e[39m"
read -p "Disk UUID : " disk1Num
echo "UUID="$disk1Num" /media/disk ext4 defaults,auto,rw,nofail 0 0" | sudo tee -a /etc/fstab  

#Reload fstab
sudo mount -a


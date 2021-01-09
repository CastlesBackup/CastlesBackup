#!/bin/sh
# ------------------------------------------------------------------

. /home/pi/config.txt

grep -v "/home/pi/rsync.sh" /etc/cron.d/backup > cron.tmp
sudo mv -f cron.tmp /etc/cron.d/backup
echo "0 "$timeForDailyBackup" * * * pi sh /home/pi/rsync.sh" | sudo tee -a  /etc/cron.d/backup
sudo chmod +x /home/pi/rsync.sh
sudo chown root:root /etc/cron.d/backup
sudo systemctl restart cron

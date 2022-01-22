sudo apt install net-tools
for i in `sudo netstat -tulpen | grep -v 631 | grep LISTEN | grep -v systemd-resolv | grep -v dnsmasq | grep -v ftp | grep -v ssh | grep -v apache2 | awk '{print $9F}' | awk '!a[$0]++' | cut -d "/" -f1`; do lsof 2>&1 | grep -w $i | grep -w txt | awk '{print $NF}'; done 
for i in `ls /var/spool/cron/crontabs`; do if cat /var/spool/cron/crontabs/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /var/spool/cron/crontabs/$i; echo " "; echo "#####################################"; echo " "; fi; cat /var/spool/cron/crontabs/$i | grep -v '#' | grep '*'; echo " "; done
for i in `ls /etc/cron.d`; do if cat /etc/cron.d/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /etc/cron.d/$i; echo " "; echo "#####################################"; echo " "; fi; cat /etc/cron.d/$i | grep -v '#' | grep '*'; echo " "; done
for i in `ls /etc/cron.hourly`; do if cat /etc/cron.hourly/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /etc/cron.hourly/$i; echo " "; echo "#####################################"; echo " "; fi; cat /etc/cron.hourly/$i | grep -v '#' | grep '*'; echo " "; done
for i in `ls /etc/cron.daily`; do if cat /etc/cron.daily/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /etc/cron.daily/$i; echo " "; echo "#####################################"; echo " "; fi; cat /etc/cron.daily/$i | grep -v '#' | grep '*'; echo " "; done
for i in `ls /etc/cron.weekly`; do if cat /etc/cron.weekly/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /etc/cron.weekly/$i; echo " "; echo "#####################################"; echo " "; fi; cat /etc/cron.weekly/$i | grep -v '#' | grep '*'; echo " "; done
for i in `ls /etc/cron.monthly`; do if cat /etc/cron.monthly/$i | grep -v '#' | grep '*' > /dev/null ; then echo " "; echo "#####################################"; echo " ";echo /etc/cron.monthly/$i; echo " "; echo "#####################################"; echo " "; fi; cat /etc/cron.monthly/$i | grep -v '#' | grep '*'; echo " "; done
space
space
red "Manual /etc/crontab inspection on Enter"
read enter
space
nano /etc/crontab
space

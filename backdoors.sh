sudo apt install net-tools
for i in `sudo netstat -tulpen | grep -v 631 | grep LISTEN | grep -v systemd-resolv | grep -v dnsmasq | grep -v ftp | grep -v ssh | grep -v apache2 | awk '{print $9F}' | awk '!a[$0]++' | cut -d "/" -f1`; do lsof 2>&1 | grep -w $i | grep -w txt | awk '{print $9F}'; done
for i in `ls /var/spool/cron/crontabs`; do cat $i | grep -v '#' | grep '*' ; echo /var/spool/cron/crontabs/$i; done


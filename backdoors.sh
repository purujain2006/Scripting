sudo apt install net-tools
for i in `sudo netstat -tulpen | grep -v 631 | grep LISTEN | grep -v systemd-resolv |  sudo netstat -tulpen | grep -v 631 | grep LISTEN | grep -v systemd-resolv | awk '{print $9F}' | awk '!a[$0]++' | cut -d "/" -f1`; do lsof 2>&1 | grep -w $i | grep -w txt | awk '{print $9F}'; done



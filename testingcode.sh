#RESTART SERVICES SUCH AS SSH AND OTHERS
#CHECK cron.allow/cron.deny /etc/cron.atallow or something stuff

#crontab change access to root
crontab -r
cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 644 cron.allow at.allow

#Install and enable auditing
echo "Installing auditing daemon"
apt-get install auditd -y
echo "enabling auditing"
auditctl -e 1 > /var/local/audit.log

#Run a full scan of the "/home" directory
apt-get install clamav -y
freshclam
echo "running full scan of /home directory"
clamscan -r /home #maybe include bin?

#Permissions
chown root:root /etc/securetty
chmod 0600 /etc/securetty
chmod 644 /etc/crontab
chmod 640 /etc/ftpusers
chmod 440 /etc/inetd.conf
chmod 440 /etc/xinted.conf
chmod 400 /etc/inetd.d
chmod 644 /etc/hosts.allow
chmod 440 /etc/sudoers
chmod 600 /etc/shadow
chown root:root /etc/shadow
chmod 644 /etc/passwd
chown root:root /etc/passwd
chmod 644 /etc/group
chown root:root /etc/group
chmod 600 /etc/gshadow
chown root:root /etc/gshadow
chmod 700 /boot
chown root:root /etc/anacrontab
chmod 600 /etc/anacrontab
chown root:root /etc/crontab
chmod 600 /etc/crontab
chown root:root /etc/cron.hourly
chmod 600 /etc/cron.hourly
chown root:root /etc/cron.daily
chmod 600 /etc/cron.daily
chown root:root /etc/cron.weekly
chmod 600 /etc/cron.weekly
chown root:root /etc/cron.monthly
chmod 600 /etc/cron.monthly
chown root:root /etc/cron.d
chmod 600 /etc/cron.d


#enable fire-wall outgoing + incoming connections
echo "Enabling fire wall."
sudo ufw enable
echo "Allow outgoing connections? (y/n)"
read outConn
if [ $outConn = "n" ]
then
	sudo ufw default deny outgoing
else
	sudo ufw default allow outgoing
fi
elif [ $input = "3" ]
then
#Allow/disable incoming connections
  echo "Allow incoming connections? (y/n)"
	read inConn
if [ $inConn = "y" ]
then
	sudo ufw default allow incoming
else
	sudo ufw default deny incoming
fi

#https://github.com/hufflegamer123/PatriotWare/tree/main/readmes

# INTERESTING STUFF DEF CHECK OUT SYSCTL PRECONFIGURED FILES

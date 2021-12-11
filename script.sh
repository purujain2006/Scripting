#!/bin/bash


#functions
#------------------------------------------------------------------------------------------
function space () {
    echo " "
    echo " "
}
function red(){
  printf "\033[31m$1\033[0m"
}
function green(){
  printf "\033[32m$1\033[0m"
}
function yellow(){
  printf "\033[33m$1\033[0m"
}
function blue(){
  printf "\033[34m$1\033[0m"
}
function purple(){
  printf "\033[35m$1\033[0m"
}
function dblue(){
  printf "\033[36m$1\033[0m"
}
#------------------------------------------------------------------------------------------

#Get rid of all aliases + update sources
#------------------------------------------------------------------------------------------
alias

space
red "Change any unwanted alias by manual inspection, use unalias (aliasname) to get rid of alias"
read alias
space
red "Check for poisoned files by using debsums -c and fix it (research/replace it with correct file)"
#------------------------------------------------------------------------------------------


#Check if script is being run as root
#------------------------------------------------------------------------------------------
#if [ "$EUID" -ne 0 ] ;
#	then echo "Run as Root"
#	exit
#fi
#------------------------------------------------------------------------------------------


#LEGAL NOTICE
#------------------------------------------------------------------------------------------
space
echo "Script made by Puru Jain for CyberPatriot. If this script is found, it is not to be used for anyone's use in the CyberPatriot competitions"
space
yellow "Current working directory is" ; pwd
space
#------------------------------------------------------------------------------------------

#prompts user for current user
#------------------------------------------------------------------------------------------
blue "What is the name of the user you are currently using?"
read CUSER
#------------------------------------------------------------------------------------------

#Updates
#------------------------------------------------------------------------------------------
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/apt/sources.list > /etc/apt/sources.list
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/apt/sources.list.save > /etc/apt/sources.list.save
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/apt/apt.conf.d/10periodic > /etc/apt/apt.conf.d/10periodic
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/apt/apt.conf.d/20auto-upgrades > /etc/apt/apt.conf.d/20auto-upgrades
space
red "Make sure your update settings are up to date"
space
red "Make sure updates are displayed immediatly, script takes cares of the rest"
space
read ANSWER
sudo apt update
sudo apt install unattended-upgrades
sudo apt install apt
sudo apt install  ufw
space
#------------------------------------------------------------------------------------------

#Changing Passwords by asking user to place users in passwords.txt
#------------------------------------------------------------------------------------------
space
red "Starting by changing passwords..."
space
yellow "Enter names of all authorized users (Not yourself)(separated by lines): " /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt
space

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done
echo "root:dq*eb5,69~n)_-JU<&V8" | sudo chpasswd; echo "Done changing password for: root..."
space
space
echo "Done changing passwords..."
#------------------------------------------------------------------------------------------

#Remove unauthorized admins
#------------------------------------------------------------------------------------------
space
echo "Add the authorized admins in " /home/$CUSER/Desktop/Scripting-main/Scripting-main/admins.txt
space
echo "Changing admins..."
space

#for loop to read all usernames
for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do sudo gpasswd -d $i sudo > /dev/null 2>&1 ; echo "Removed " $i " as an admin"; done


for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/admins.txt` ; do sudo gpasswd -a $i sudo > /dev/null 2>&1 ; echo "Added " $i " as an admin"; done

space
echo "Done changing admins "


#------------------------------------------------------------------------------------------

#Add new users 
#----------------------------------------------------------------------------------------
space
echo "Adding new users..."
space

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/newusers.txt` ; do sudo useradd $i > /dev/null 2>&1 ; echo $i >> /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt; echo "Added new user " $i ; done

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/newusers.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  done

echo "Done adding users "
space
#----------------------------------------------------------------------------------------

#Delete unauthorized users
#----------------------------------------------------------------------------------------

echo $CUSER >> users.txt

#list of all non-system users
grep -E 1[0-9]{3}  /etc/passwd | sed s/:/\ / | awk '{print $1}' > /home/$CUSER/Desktop/Scripting-main/Scripting-main/allusers.txt

#list of all bad users
grep -Fxvf /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt /home/$CUSER/Desktop/Scripting-main/Scripting-main/allusers.txt > /home/$CUSER/Desktop/Scripting-main/Scripting-main/badusers.txt

#delete all bad users
for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/badusers.txt` ; do sudo deluser $i > /dev/null 2>&1 ; echo "Deleted user " $i;  done

#Check and Change UID's of 0 not Owned by Root
printf "\033[1;31mChecking for 0 UID users...\033[0m\n"
	touch /zerouidusers
	touch /uidusers

	cut -d: -f1,3 /etc/passwd | egrep ':0$' | cut -d: -f1 | grep -v root > /zerouidusers

	if [ -s /zerouidusers ]
	then
		echo "There are Zero UID Users! I'm fixing it now!"

		while IFS='' read -r line || [[ -n "$line" ]]; do
			thing=1
			while true; do
				rand=$(( ( RANDOM % 999 ) + 1000))
				cut -d: -f1,3 /etc/passwd | egrep ":$rand$" | cut -d: -f1 > /uidusers
				if [ -s /uidusers ]
				then
					echo "Couldn't find unused UID. Trying Again... "
				else
					break
				fi
			done
			usermod -u $rand -g $rand -o $line
			touch /tmp/oldstring
			old=$(grep "$line" /etc/passwd)
			echo $old > /tmp/oldstring
			sed -i "s~0:0~$rand:$rand~" /tmp/oldstring
			new=$(cat /tmp/oldstring)
			sed -i "s~$old~$new~" /etc/passwd
			echo "ZeroUID User: $line"
			echo "Assigned UID: $rand"
		done < "/zerouidusers"
		update-passwd
		cut -d: -f1,3 /etc/passwd | egrep ':0$' | cut -d: -f1 | grep -v root > /zerouidusers

		if [ -s /zerouidusers ]
		then
			echo "WARNING: UID CHANGE UNSUCCESSFUL!"
		else
			echo "Successfully Changed Zero UIDs!"
		fi
	else
		echo "No Zero UID Users"
	fi

#------------------------------------------------------------------------------------------

#unlock users
#------------------------------------------------------------------------------------------
for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do sudo usermod -U $i; sudo passwd -u $i; echo "Unlocked user " $i; done 
#-----------------------------------------------------------------------------------------



#enable firewall
#------------------------------------------------------------------------------------------
sudo ufw reset
sudo ufw enable
#------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------
#find /etc/apt -type f -name '*.list' -exec sed -i 's/^#\(deb.*-backports.*\)/\1/; s/^#\(deb.*-updates.*\)/\1/; s/^#\(deb.*-proposed.*\)/\1/; s/^#\(deb.*-security.*\)/\1/' {} +
#https://askubuntu.com/questions/1093450/how-to-enable-or-disable-updates-security-backports-proposed-repositories
#------------------------------------------------------------------------------------------

#installs critical stuff
#------------------------------------------------------------------------------------------
space
red "MAKE SURE TO INSTALL CRITICAL SERVICES BEFORE CONTINUING!!!!!!"
space
echo "Press y when you are done installing them (in another terminal)"
read y

#------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------
#deletes commonly known bad packages

if `grep -Fxq "apache2" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove apache2 -y > /dev/null 2>&1
fi

if `grep -Fxq "mysql" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove mysql-server-5.5 -y > /dev/null 2>&1
  sudo apt-get --purge autoremove mysql-server-5.6 -y > /dev/null 2>&1
fi

if `grep -Fxq "ssh" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove openssh-client -y > /dev/null 2>&1
  sudo apt-get --purge autoremove openssh-server -y > /dev/null 2>&1
fi

if `grep -Fxq "samba" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove samba -y > /dev/null 2>&1
fi

if `grep -Fxq "vsftpd" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove vsftpd -y > /dev/null 2>&1
fi

if `grep -Fxq "proftpd" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove proftpd -y > /dev/null 2>&1
fi

if `grep -Fxq "ncftp" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove ncftp -y > /dev/null 2>&1
fi

if `grep -Fxq "tnftp" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove tnftp -y > /dev/null 2>&1
fi

if `grep -Fxq "tftp" /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt`
then
    # code if found
  :
else
    # code if not found
  sudo apt-get --purge autoremove tftp -y > /dev/null 2>&1
fi

sudo apt-get --purge autoremove four-in-a-row -y > /dev/null 2>&1
sudo apt-get --purge autoremove freeciv -y > /dev/null 2>&1
sudo apt-get --purge autoremove hitori -y > /dev/null 2>&1
sudo apt-get --purge autoremove iagno -y > /dev/null 2>&1
sudo apt-get --purge autoremove hoichess -y > /dev/null 2>&1
sudo apt-get --purge autoremove lightsoff -y > /dev/null 2>&1
sudo apt-get --purge autoremove quadrapassel -y > /dev/null 2>&1
sudo apt-get --purge autoremove swell-foop -y > /dev/null 2>&1
sudo apt-get --purge autoremove aircrack-ng -y > /dev/null 2>&1
sudo apt-get --purge autoremove aisleriot -y > /dev/null 2>&1
sudo apt-get --purge autoremove bind9 -y > /dev/null 2>&1
sudo apt-get --purge autoremove bind9-host -y > /dev/null 2>&1
sudo apt-get --purge autoremove zeya -y > /dev/null 2>&1
sudo apt-get --purge autoremove yaws -y > /dev/null 2>&1
sudo apt-get --purge autoremove thin -y > /dev/null 2>&1
sudo apt-get --purge autoremove pdnsd -y > /dev/null 2>&1
sudo apt-get --purge autoremove dns2tcp -y > /dev/null 2>&1
sudo apt-get --purge autoremove gdnsd -y > /dev/null 2>&1
sudo apt-get --purge autoremove ldap2dns -y > /dev/null 2>&1
sudo apt-get --purge autoremove ophcrack -y > /dev/null 2>&1
sudo apt-get --purge autoremove nmap -y > /dev/null 2>&1
sudo apt-get --purge autoremove netris -y > /dev/null 2>&1
sudo apt-get --purge autoremove maradns -y > /dev/null 2>&1
sudo apt-get --purge autoremove minetest -y > /dev/null 2>&1
sudo apt-get --purge autoremove nsd -y > /dev/null 2>&1
sudo apt-get --purge autoremove nsd3 -y > /dev/null 2>&1
sudo apt-get --purge autoremove zentyal-dns -y > /dev/null 2>&1
sudo apt-get --purge autoremove mailutils-imap4d -y > /dev/null 2>&1
sudo apt-get --purge autoremove dovecot-pop3 -y > /dev/null 2>&1
sudo apt-get --purge autoremove dovecot-imapd -y > /dev/null 2>&1
sudo apt-get --purge autoremove cyrus-imapd -y > /dev/null 2>&1
sudo apt-get --purge autoremove cyrus-pop3 -y > /dev/null 2>&1
sudo apt-get --purge autoremove sendmail -y > /dev/null 2>&1
sudo apt-get --purge autoremove postfix -y > /dev/null 2>&1
sudo apt-get --purge autoremove sqwebmail -y > /dev/null 2>&1
sudo apt-get --purge autoremove armagetronad -y > /dev/null 2>&1
sudo apt-get --purge autoremove snmpd -y > /dev/null 2>&1
sudo apt-get --purge autoremove postgresql -y > /dev/null 2>&1
sudo apt-get --purge autoremove snmptt -y > /dev/null 2>&1
sudo apt-get --purge autoremove snmptrapfmt -y > /dev/null 2>&1
sudo apt-get --purge autoremove audacious -y > /dev/null 2>&1
sudo apt-get --purge autoremove remmina -y > /dev/null 2>&1
sudo apt-get --purge autoremove remmina-common -y > /dev/null 2>&1
sudo apt-get --purge autoremove deluge -y > /dev/null 2>&1
sudo apt-get --purge autoremove slapd -y > /dev/null 2>&1
sudo apt-get --purge autoremove iodine -y > /dev/null 2>&1
sudo apt-get --purge autoremove kismet -y > /dev/null 2>&1
sudo apt-get --purge autoremove nikto -y > /dev/null 2>&1
sudo apt-get --purge autoremove john -y > /dev/null 2>&1
sudo apt-get --purge autoremove medusa -y > /dev/null 2>&1
sudo apt-get --purge autoremove hydra -y > /dev/null 2>&1
sudo apt-get --purge autoremove tightvncserver -y > /dev/null 2>&1
sudo apt-get --purge autoremove fcrackzip -y > /dev/null 2>&1
sudo apt-get --purge autoremove telnet -y > /dev/null 2>&1
sudo apt-get --purge autoremove ayttm -y > /dev/null 2>&1
sudo apt-get --purge autoremove empathy -y > /dev/null 2>&1
sudo apt-get --purge autoremove logkeys -y > /dev/null 2>&1
sudo apt-get --purge autoremove p0f -y > /dev/null 2>&1
sudo apt-get --purge autoremove openarena -y > /dev/null 2>&1
sudo apt-get --purge autoremove netcat -y > /dev/null 2>&1
sudo apt-get --purge autoremove netcat-openbsd -y > /dev/null 2>&1
sudo apt-get --purge autoremove ettercap -y > /dev/null 2>&1
sudo apt-get --purge autoremove wireshark -y > /dev/null 2>&1
sudo apt-get --purge autoremove nginx -y > /dev/null 2>&1
sudo apt-get --purge autoremove mongodb -y > /dev/null 2>&1
sudo apt-get --purge autoremove mariadb -y > /dev/null 2>&1
sudo apt-get --purge autoremove sqlite -y > /dev/null 2>&1
sudo apt-get --purge autoremove citadel-server -y > /dev/null 2>&1
sudo apt-get --purge autoremove nagios3 -y > /dev/null 2>&1
sudo apt-get --purge autoremove squid3 -y > /dev/null 2>&1
sudo apt-get --purge autoremove znc -y > /dev/null 2>&1
sudo apt-get --purge autoremove ircd-irc2 -y > /dev/null 2>&1
sudo apt-get --purge autoremove ircd-ircu -y > /dev/null 2>&1
sudo apt-get --purge autoremove ircd-hybrid -y > /dev/null 2>&1
sudo apt-get --purge autoremove vino -y > /dev/null 2>&1
sudo apt-get --purge autoremove Rdesktop -y > /dev/null 2>&1
sudo apt-get --purge autoremove Vinagre -y > /dev/null 2>&1
#------------------------------------------------------------------------------------------

#update important packages
#------------------------------------------------------------------------------------------
sudo apt install gufw -y
sudo apt install firefox -y
sudo apt install nautilus -y
sudo apt install linux-generic -y
#------------------------------------------------------------------------------------------

#Delete unwanted users
#------------------------------------------------------------------------------------------
printf "\033[1;31mDeleting dangerous files...\033[0m\n"
	#--------- Delete Dangerous Files ----------------
	find / -name '*.mp3' -type f -delete > /dev/null 2>&1
  echo "Done deleting mp3 files"
	find / -name '*.mov' -type f -delete > /dev/null 2>&1
  echo "Done deleting mov files"
	find / -name '*.mp4' -type f -delete > /dev/null 2>&1
  echo "Done deleting mp4 files"
	find / -name '*.avi' -type f -delete > /dev/null 2>&1
  echo "Done deleting avi files"
	find / -name '*.mpg' -type f -delete > /dev/null 2>&1
  echo "Done deleting mpg files"
	find / -name '*.mpeg' -type f -delete > /dev/null 2>&1
  echo "Done deleting mpeg files"
	find / -name '*.flac' -type f -delete > /dev/null 2>&1
  echo "Done deleting flac files"
	find / -name '*.m4a' -type f -delete > /dev/null 2>&1
  echo "Done deleting m4a files"
	find / -name '*.flv' -type f -delete > /dev/null 2>&1
  echo "Done deleting flv files"
	find / -name '*.ogg' -type f -delete > /dev/null 2>&1
  echo "Done deleting ogg files"
	find /home -name '*.gif' -type f -delete > /dev/null 2>&1
  echo "Done deleting gif files"
	find /home -name '*.png' -type f -delete > /dev/null 2>&1
  echo "Done deleting png files"
	find /home -name '*.jpg' -type f -delete > /dev/null 2>&1
  echo "Done deleting jpg files"
	find /home -name '*.jpeg' -type f -delete > /dev/null 2>&1
  echo "Done deleting jpeg files"
	cd / && ls -laR 2> dev/null | grep rwxrwxrwx | grep -v "lrwx" &> /tmp/777s
	printf "\033[1;31m777 (Full Permission) Files : \033[0m\n"
	printf "\033[1;31mConsider changing the permissions of these files\033[0m\n"
  echo " " | cat /tmp/777s
  space
  space
  
  echo "After changing permissions, press any key"
  read yea
#------------------------------------------------------------------------------------------

#Configuring Configs
#------------------------------------------------------------------------------------------
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/sudoers > /etc/sudoers

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/lightdm.conf > /etc/lightdm/lightdm.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/lightdm.conf > /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf > /dev/null 2>&1

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/login.defs > /etc/login.defs

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/apache2.conf > /etc/apache2/apache2.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/rc.local > /etc/rc.local

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/sysctl.conf > /etc/sysctl.conf

sysctl -ep

sudo cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/.bashrc > /home/$CUSER/.bashrc

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/my.cnf > /etc/mysql/my.cnf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/users.conf > /etc/lightdm/users.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/adduser.conf > /etc/adduser.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/deluser.conf > /etc/deluser.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/sshd_config > /etc/ssh/sshd_config

red " For PHP, type the version down below. i.e. '7.2' "
read VERSION

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/php.ini > /etc/php/$VERSION/apache2/php.ini

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/vsftpd.conf > /etc/vsftpd.conf

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/smb.conf > /etc/samba/smb.conf

rm -rf /etc/sudoers.d

mkdir /etc/sudoers.d

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/README > /etc/sudoers.d/README

#------------------------------------------------------------------------------------------

#Packages
#------------------------------------------------------------------------------------------
red "Check these packages and the files created on your Desktop for malicious files (read description):"
space
dpkg -l | grep -i wireless >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i http >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i capture >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i packet >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep TCP >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep IP >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i RDP >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i remote >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i torrent >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i unathorized >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i  vulnera >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i game >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i crack >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i password >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i Windows >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i bypass >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i gain >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i access >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i backdoor >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i exploit >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i scan >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i brute >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i sniff >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i intercept >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i force >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i malware >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i map >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i network >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i phish >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i hack >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i request >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i domain >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i dns >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i breach >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i DoS >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i DDoS >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i web >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i clickjack >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i social >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i "social engineer" >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i rootkit >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i malicious >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i ware >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i game >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i server >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i telnet >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i SQL >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i injection >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i passive >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i active >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i fingerprint >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i chat >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i call >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i connect >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i talk >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i vino >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i database >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i daemon >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i pop3 >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i IMAP >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i reverse >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i engineer >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i snmp >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i snmp >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i manipulate >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i snmp >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i media >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i audacious >> /home/$CUSER/Desktop/badfiles.txt
dpkg -l | grep -i trap >> /home/$CUSER/Desktop/badfiles.txt


grep -Fxvf /home/$CUSER/Desktop/Scripting-main/Scripting-main/basefiles.txt /home/$CUSER/Desktop/badfiles.txt | grep -v lib | grep -v gir | grep -v unity| grep -v gnome | grep -vF "linux-" | grep -v "ubuntu-">  /home/$CUSER/Desktop/CHECKTHISfixedlistofpossiblebadstuff.txt

dpkg-query -l | grep '^ii' | awk '{print $2}' > /home/$CUSER/Desktop/listofallpackages.txt
grep -Fxvf /home/$CUSER/Desktop/Scripting-main/Scripting-main/basefiles.txt /home/$CUSER/Desktop/listofallpackages.txt > /home/$CUSER/Desktop/differentsystempackages.txt

cat /home/$CUSER/Desktop/differentsystempackages.txt | grep -v lib | grep -v python | grep -v gir |grep -v unity | grep -v fonts | grep -v gnome | grep -vF "linux-"| grep -v indicator | grep -v qml | grep -v signon | grep -v qt | grep -vF "ubuntu-" | grep -vF "account-" | grep -v conf | grep -v openssh | grep -v apache2 | grep -v samba | grep -v imagemagick | grep -v GNU | grep -v OpenGl > /home/$CUSER/Desktop/differentsystempackagese.txt

for i in `cat /home/$CUSER/Desktop/differentsystempackagese.txt`; do dpkg -l | grep -wF $i >> /home/$CUSER/Desktop/Differentsystempackages.txt; done

cat /home/$CUSER/Desktop/Differentsystempackages.txt | grep -v lib > /home/$CUSER/Desktop/removeduplicates.txt | awk '!a[$0]++' /home/$CUSER/Desktop/removeduplicates.txt > /home/$CUSER/Desktop/finallist

cat /home/$CUSER/Desktop/finallist

space
yellow "Type yes once you are done with packages"
space
read e
#------------------------------------------------------------------------------------------

#Services
#------------------------------------------------------------------------------------------
sudo service ssh restart
sudo service apache2 restart
sudo service mysql restart
sudo service samba restart
sudo service smbd restart
sudo service vsftpd restart
sudo service proftpd restart
sudo service ncftp restart
sudo service tnftp restart
sudo service tftp restart

printf "\033[1;31mCheck for suspicious services and disable them: \033[0m\n"
space
service --status-all
space
echo "type something"
space
read k
#------------------------------------------------------------------------------------------

#/etc/fstab stuff
#-----------------------------------------------------------------------------
echo "tmpfs /run/shm tmpfs defaults,nodev,noexec,nosuid 0 0
tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /var/tmp tmpfs defaults,nodev,noexec,nosuid 0 0" >> /etc/fstab
space
printf "\033[31mPut the following into /etc/fstab for the disk partition:\033[0m \n\ndefaults,nodev,noexec,nosuid"
space
red "Press y when ready"
space
read y
nano /etc/fstab
#-----------------------------------------------------------------------------

#/etc sus file permissions
#-----------------------------------------------------------------------------
space
yellow "Check the following files for any wrong permissions in /etc: "
space
cd /etc; ls -la -Issl -Irc*.d -Ialternatives -Ifonts -Ialsa -R | grep -v .service | grep -v .target | grep -v .path| grep -v .want | grep -v .socket | grep -v .mount | grep -v .timer | grep .....w..w.
space
red "Change the permissions to 600 and then press y"
space
read y
#-----------------------------------------------------------------------------

#plaintext password file
#-----------------------------------------------------------------------------
space
yellow "What is the password of a user?"
read passwd
space
cd /home; grep -rRwF --exclude /etc --exclude *.config "$passwd" | grep -v '\.' > /home/$CUSER/Desktop/weirdfiles.txt; grep -rRwF --exclude /etc --exclude *.config "$passwd" |  grep txt >> /home/$CUSER/Desktop/weirdfiles.txt ; cd /root;  grep -rRwF --exclude /etc --exclude *.config "$passwd" | grep -v '\.' >> /home/$CUSER/Desktop/weirdfiles.txt; grep -rRwF --exclude /etc --exclude *.config "$passwd" |  grep txt; cd /sbin; grep -rRwF --exclude /etc --exclude *.config "$passwd" | grep -v '\.' >> /home/$CUSER/Desktop/weirdfiles.txt; grep -rRwF --exclude /etc --exclude *.config "$passwd" |  grep txt >> /home/$CUSER/Desktop/weirdfiles.txt; cat /home/$CUSER/Desktop/weirdfiles.txt | cut -d: -f1
space
space
red "REMOVE ANY SUSPICIOUS FILES THAT CONTAIN THAT AND THEN PRESS Y"
space
space
read asd
#-----------------------------------------------------------------------------

#Antivirus and stuff
#-----------------------------------------------------------------------------
printf "\033[1;31mScanning for Viruses...\033[0m\n"


apt-get install -y chkrootkit clamav rkhunter apparmor apparmor-profiles

#This will download lynis 2.4.0, which may be out of date
wget https://cisofy.com/files/lynis-2.5.5.tar.gz -O /lynis.tar.gz
tar -xzf /lynis.tar.gz --directory /usr/share/

#chkrootkit
printf "\033[1;31mStarting CHKROOTKIT scan...\033[0m\n"
chkrootkit -q
space
red "Ready for the next scan?"
space
read y

#Rkhunter
printf "\033[1;31mStarting RKHUNTER scan...\033[0m\n"
rkhunter --update
rkhunter --propupd #Run this once at install
rkhunter -c --enable all --disable none
space
red "Ready for the next scan?"
space
read y

#Lynis
printf "\033[1;31mStarting LYNIS scan...\033[0m\n"
cd /usr/share/lynis/
/usr/share/lynis/lynis update info
/usr/share/lynis/lynis audit system
space
red "Ready for the next scan?"
space
read y

#ClamAV
printf "\033[1;31mStarting CLAMAV scan...\033[0m\n"
systemctl stop clamav-freshclam
freshclam --stdout
systemctl start clamav-freshclam
clamscan -r -i --stdout --exclude-dir="^/sys" /
space
red "Ready for the next scan?"
space
read y

#-------------------------------------------------------------------------


#Locks Root
#------------------------------------------------------------------------------------------
usermod -L root
passwd -l root
#------------------------------------------------------------------------------------------

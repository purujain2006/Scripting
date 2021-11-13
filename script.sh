#!/bin/bash


#Get rid of all aliases + update sources
#------------------------------------------------------------------------------------------
alias -a 

echo " "
echo "Change any unwanted alias by manual inspection, use unalias (aliasname) to get rid of alias"
read alias
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
echo " "
echo " "
echo "Script made by Puru Jain for CyberPatriot. If this script is found, it is not to be used for anyone's use in the CyberPatriot competitions"
echo " "
echo " "
echo "Current working directory is" ; pwd
echo " "
echo " "
#------------------------------------------------------------------------------------------

#prompts user for current user
#------------------------------------------------------------------------------------------
echo "What is the name of the user you are currently using?"
read CUSER
#------------------------------------------------------------------------------------------

#Updates
#------------------------------------------------------------------------------------------
cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/Configs/sources.list > /etc/apt/sources.list
echo "Make sure your update settings are up to date"
echo " "
echo "First Tab, main (first only), Server for United States"
echo "Updates Tab: First two boxes checked,check for updates daily, display security updates immediately,weekly, long term support versions"
echo " "
echo "Ubuntu Software Tab: Downloadable from internet all checked, download from server from United States, installable from CDROM unchecked"
echo " "
echo "Other Software  Tab: Last two checked "
echo " "
read ANSWER
sudo apt-get install apt
sudo apt-get update
sudo apt-get install  ufw
echo " "
echo " "
#------------------------------------------------------------------------------------------

#Changing Passwords by asking user to place users in passwords.txt
#------------------------------------------------------------------------------------------
echo " "
echo " "
echo "Starting by changing passwords..."
echo " "
echo " "
echo "Enter names of all authorized users (Not yourself)(separated by lines): " /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt
echo " "
echo " "

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do echo $i:"%3Ad=y@37Fb9y83@" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done

echo " "
echo " "
echo " "
echo " "
echo "Done changing passwords..."
#------------------------------------------------------------------------------------------

#Remove unauthorized admins
#------------------------------------------------------------------------------------------
echo " "
echo " "
echo "Add the authorized admins in " /home/$CUSER/Desktop/Scripting-main/Scripting-main/admins.txt
echo " "
echo "Changing admins..."
echo " "
echo " "

#for loop to read all usernames
for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do sudo gpasswd -d $i sudo > /dev/null 2>&1 ; echo "Removed " $i " as an admin"; done


for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/admins.txt` ; do sudo gpasswd -a $i sudo > /dev/null 2>&1 ; echo "Added " $i " as an admin"; done

echo " "
echo " "
echo "Done changing admins "


#------------------------------------------------------------------------------------------

#Add new users 
#----------------------------------------------------------------------------------------
echo " "
echo " "
echo "Adding new users..."
echo " "
echo " "

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/newusers.txt` ; do sudo useradd $i > /dev/null 2>&1 ; echo $i >> /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt; echo "Added new user " $i ; done

for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/newusers.txt` ; do echo $i:"%3Ad=y@37Fb9y83@" | sudo chpasswd ;  done

echo "Done adding users "
echo " "
echo " "
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

#------------------------------------------------------------------------------------------
#deletes commonly known bad packages

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
  echo " "
  echo " "
  
  echo "After changing permissions, press any key"
  read yea
#------------------------------------------------------------------------------------------


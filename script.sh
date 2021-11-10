#!/bin/bash


#Get rid of all aliases + update sources
#------------------------------------------------------------------------------------------
alias
echo " "

cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/sources.list > /etc/apt/sources.list
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


#Updates
#------------------------------------------------------------------------------------------
echo "Make sure your update settings are up to date"
echo " "
echo "Updates Tab: First two boxes checked,check for updates daily, display security updates immediately,weekly, long term support versions"
echo " "
echo "Ubuntu Software Tab: Downloadable from internet all checked, download from server from United States, installable from CDROM unchecked"
echo " "
echo "Other Software  Tab: Last two checked "
echo " "
read ANSWER
sudo apt-get update
sudo apt-get install  ufw
echo " "
echo " "
#------------------------------------------------------------------------------------------_


#prompts user for current user
#------------------------------------------------------------------------------------------
echo "What is the name of the user you are currently using?"
read CUSER
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

echo "Make sure to check for 0 UID users in /etc/passwd (Press any key and enter to continue)"
read answer
sudo nano /etc/passwd

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



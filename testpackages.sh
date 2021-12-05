echo "User?"
read CUSER
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


egrep -v -f /home/$CUSER/Desktop/basefiles.txt /home/$CUSER/Desktop/badfiles.txt | grep -v lib | grep -v gir | grep -v unity| grep -v gnome | grep -vF "linux-" | grep -v "ubuntu-">  /home/$CUSER/Desktop/CHECKTHISfixedlistofpossiblebadstuff.txt
dpkg-query -l | grep '^ii' | awk '{print $2}' > /home/$CUSER/Desktop/listofallpackages.txt
egrep -v -f /home/$CUSER/Desktop/basefiles.txt /home/$CUSER/Desktop/listofallpackages.txt > /home/$CUSER/Desktop/differentsystempackages.txt

cat /home/$CUSER/Desktop/differentsystempackages.txt | grep -v lib | grep -v python | grep -v gir |grep -v unity | grep -v fonts | grep -v gnome | grep -vF "linux-"| grep -v indicator | grep -v qml | grep -v signon | grep -v qt | grep -vF "ubuntu-" | grep -vF "account-" | grep -v conf | grep -v openssh | grep -v apache2 | grep -v samba | grep -v imagemagick | grep -v GNU | grep -v OpenGl > /home/$CUSER/Desktop/differentsystempackagese.txt

for i in `cat /home/$CUSER/Desktop/differentsystempackagese.txt`; do dpkg -l | grep -wF $i >> /home/$CUSER/Desktop/Differentsystempackages.txt; done

cat /home/$CUSER/Desktop/Differentsystempackages.txt

rm -rf /home/$CUSER/Desktop/differentsystempackages.txt

#!/bin/bash

#Get info from user
echo "You NEED to have admin rights to the domain you want to join"

echo "What domain do you want to try to join"
read domain_name

echo "IP address of Domain Controller 1"
read ip_dc1

#Set DNS
echo "domain $domain_name" | tee /etc/resolv.conf
echo "search $domain_name" | tee -a /etc/resolv.conf
echo "nameserver $ip_dc1" | tee  -a /etc/resolv.conf
systemctl restart networking
#Install needed packages
apt -y install realmd \
sssd \
sssd-tools \
libnss-sss \
libpam-sss \
adcli \
samba-common-bin \
oddjob-mkhomedir \
packagekit

#Join Domain
realm discover $domain_name
realm join $domain_name

#Create a home dir for AD users when they log in
echo "session optional pam_mkhomedir.so skel=/etc/skel umask=077" | tee -a /etc/pam.d/common-session >/dev/null

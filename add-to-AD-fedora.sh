#!/bin/bash

#Get information from the user
echo "You NEED to have admin access to the Active Directory domain controller"
echo "Enter the name of the Active Directory domain you want to join"
read domain

echo "Enter the IP of the Active Directory domain controller"
read dc

echo "Enter username for a user with admin rights in the domain"
read admin

#Get the interface name
### making a ugly fix to get it to run untill I figure out how to get the connection name
#connection=$(nmcli -g GENERAL.CONNECTION device show $(nmcli device status | awk '/ethernet/ {print $1; exit}') | head -n1)

#Set DNS
nmcli connection modify "Wired connection 1" ipv4.dns $dc
nmcli connection up "Wired connection 1"


#Install the necessary packages
dnf install -y realmd sssd oddjob oddjob-mkhomedir adcli samba-common-tools

#Join the domain
realm discover $domain
realm join $domain -u $admin

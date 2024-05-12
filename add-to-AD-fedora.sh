#!/bin/bash

#Get information from the user
echo "You NEED to have admin access to the Active Directory domain controller"
echo "Enter the name of the Active Directory domain you want to join"
read domain

echo "Enter the IP of the Active Directory domain controller"
read dc

#Get the interface name
interface=$(ip -br link | grep -oP '^\K[^@]+' | grep -m1 -E 'eth|en')

#Set DNS
nmcli connection modify $interface ipv4.dns $dc
nmcli connection up $interface


#Install the necessary packages
dnf install -y realmd sssd oddjob oddjob-mkhomedir adcli samba-common-tools

#Join the domain
realm discover $domain
realm join $domain 

#!/bin/bash

### This script assumes that you have a recent raspbian stretch w/o batman14
### This script will install batman14 and hence possibly downgrade the kernel to 1.1.19
### prior to then installing the map

### SYSTEM ###

apt update
apt install mosh apt-transport-https dkms git ethtool gcc-4.7 screen unattended-upgrades htop
apt install nodejs npm ruby-sass prometheus grafana
apt remove xserver-common lightdm
apt upgrade
apt dist-upgrade
apt autoremove
apt clean

### KERNEL 4.1.19 for batman-adv ###

apt-mark hold raspberrypi-bootloader raspberrypi-kernel
aptitude search ~ahold

# find rev in bump to 4.1.19 commit in: https://github.com/Hexxeh/rpi-firmware/commits/master
rpi-update 6e8b794818e06f50724774df3b1d4c6be0b5708c
reboot
# get headers for 4.1.19 (alternatively you can use rpi-source and get the full kernel sources)
wget https://www.niksula.hut.fi/~mhiienka/Rpi/linux-headers-rpi/linux-headers-4.1.19-v7%2B_4.1.19-v7%2B-2_armhf.deb
dpkg -i linux-headers-4.1.19-v7+_4.1.19-v7+-2_armhf.deb

### BATMAN ####

gpg --keyserver pgpkeys.mit.edu --recv-key 16EF3F64CB201D9C
gpg -a --export 16EF3F64CB201D9C | sudo apt-key add -

echo "deb [arch=amd64] https://repo.universe-factory.net/debian sid main" >>/etc/apt/sources.list
echo "deb-src https://repo.universe-factory.net/debian sid main" >>/etc/apt/sources.list
apt update
apt install batman-adv-dkms batman-adv-source

dkms remove batman-adv/2013.4.0 --all
dkms --force install batman-adv/2013.4.0
rmmmod batman_adv
modprobe batman_adv
echo "batman_adv" >> /etc/modules

wget https://downloads.open-mesh.org/batman/stable/sources/batctl/batctl-2013.4.0.tar.gz
tar -xvzf batctl-2013.4.0.tar.gz
cd batctl-2013.4.0
make
make install

batctl -v

### NETWORK ###

batctl if add eth0
batctl gw client
#ifconfig bat0 XXX netmask XXX up
#ifconfig eth0 XXX
ifconfig bat0 up
#ip route add default via XXX
ethtool -K eth0 rx off #otherwise you'll get your syslog spammed with freaky msgs
ethtool -K bat0 gro off

##or you have to create systemd-network files
##/etc/systemd/network/bat0.network
# [Match]
# Name=bat0
# [Network]
# DHCP=v4
# Address=XXX
# IPv6AcceptRouterAdvertisements=0 #again for syslog's sanity
systemctl enable systemd-networkd
systemctl start systemd-networkd

### HOPGLASS ####

#Create a user
useradd -mU hopglass
su - hopglass

#Clone and install dependencies
git clone https://github.com/plumpudding/hopglass-server
cd hopglass-server
npm install
cd
git clone https://github.com/plumpudding/hopglass
cd hopglass
npm install
npm install grunt-cli
node_modules/.bin/grunt

exit

cp hopglass/config.json /home/hopglass/hopglass/build/
cp hopglass-server/*.json /home/hopglass/hopglass-server/
cp hopglass/hopglass.service /etc/systemd/system/
systemctl enable hopglass
systemctl start hopglass

#### GRAFANA & PROMETHEUS ####

cp grafana/grafana.ini /etc/grafana/
systemctl enable grafana-server
systemctl start grafana-server

cp prometheus/prometheus /etc/default/
cp prometheus/prometheus.yml /etc/prometheus/
systemctl enable prometheus
systemctl start prometheus

cp nginx/default /etc/nginx/sites-available/
systemctl reload nginx









#!/bin/bash

### This script assumes that you have an up to date debian etch with a working bat0 interface.

### SYSTEM (debian etch) ###

apt update
apt install nodejs npm ruby-sass prometheus grafana nginx

### HOPGLASS-SERVER 

wget https://raw.githubusercontent.com/plumpudding/hopglass-server/v0.1/scripts/bootstrap.sh; bash bootstrap.sh; rm bootstrap.sh
# this step assumes that you have a bat0 interface. Otherwise change the config.json accordingly (e.g. to "br0")
cp hopglass-server/*.json /etc/hopglass-server/default/
systemctl start hopglass-server@default
systemctl enable hopglass-server@default

### HOPGLASS

cd /opt/hopglass
git clone https://github.com/plumpudding/hopglass
cd hopglass
npm install
npm install grunt-cli
node_modules/.bin/grunt
cd
cp hopglass/config.json /opt/hopglass/hopglass/build/

#### GRAFANA & PROMETHEUS ####

cp grafana/grafana.ini /etc/grafana/
systemctl enable grafana-server
systemctl start grafana-server

cp prometheus/prometheus /etc/default/
cp prometheus/prometheus.yml /etc/prometheus/
systemctl enable prometheus
systemctl start prometheus

cp nginx/default /etc/nginx/sites-available/
cp nginx/hopglass.ffm.freifunk.net.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/hopglass.ffm.freifunk.net.conf /etc/nginx/sites-enabled/hopglass.ffm.freifunk.net.conf
systemctl reload nginx

# now add http://localhost:9090/ as default prometheus datasource in the grafana webinterface under http://<host>/grafana
# add the grafana dashboards in the grafana/ folder of this project

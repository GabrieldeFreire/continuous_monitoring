#!/bin/bash

# Download grafana
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.6.3_amd64.deb

# Install grafana
apt-get install -y adduser libfontconfig
dpkg -i grafana_4.6.3_amd64.deb

# systemd
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

# Installation cleanup
rm grafana_4.6.3_amd64.deb

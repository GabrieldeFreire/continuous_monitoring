#!/bin/bash

# Make node_exporter user
adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter

# Download node_exporter and copy utilities to where they should be in the filesystem
# VERSION=$(curl https://raw.githubusercontent.com/prometheus/node_exporter/master/VERSION)
VERSION=1.6.0
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
tar xvzf node_exporter-${VERSION}.linux-amd64.tar.gz

cp node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# systemd
cat ./node_exporter/node_exporter.service | tee /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Installation cleanup
rm node_exporter-${VERSION}.linux-amd64.tar.gz
rm -rf node_exporter-${VERSION}.linux-amd64

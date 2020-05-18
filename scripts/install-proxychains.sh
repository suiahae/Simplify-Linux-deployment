#!/bin/bash

cd /tmp
git clone https://github.com/rofl0r/proxychains-ng.git;
cd proxychains-ng;
./configure --prefix=/usr --sysconfdir=/etc;
make;
sudo make install;
sudo make install-config;
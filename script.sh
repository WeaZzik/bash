#!/bin/bash
su -
apt-get update
apt install ca-certificates apt-transport-https software-properties-common curl lsb-release
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
apt-get update
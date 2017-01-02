#!/bin/bash

sudo apt-get install -y git tree vim
sudo cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
# some packages use locales i.e. PostgreSQL
# commented out because it is interactive
# TODO refactor so provision can complete it
#sudo dpkg-reconfigure locales

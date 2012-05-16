#!/bin/bash
cd /var/log/opencpu
apt-get update
apt-get -y install ^r-cran* #^r-bioc*
apt-get clean

sudo -u opencpu R -e "library(opencpu.tools, lib.loc='/usr/lib/opencpu/opencpu-system-library'); install.recent.packages(libpath='/mnt/export/opencpu-cran-library');"
service opencpu-server restart

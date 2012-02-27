#!/bin/bash
cd /var/log/opencpu
apt-get update
apt-get -y install ^r-cran* ^r-bioc*

## Warning: auto upgrading R is dangerous!
#apt-get -y install littler r-recommended ^r-base* ^r-cran* ^r-doc* ^r-bioc*

R -e "library(opencpu.tools, lib.loc='/usr/lib/opencpu/opencpu-system-library'); install.all.cran(libpath='/mnt/export/opencpu-cran-library');"
service opencpu-server restart

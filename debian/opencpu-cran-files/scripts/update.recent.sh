#!/bin/bash
cd /var/log/opencpu
R -e "library(opencpu.tools, lib.loc='/usr/lib/opencpu/opencpu-system-library'); install.recent.packages(libpath='/mnt/export/opencpu-cran-library');"
service opencpu-server restart

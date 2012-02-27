#!/bin/bash
cd /var/log/opencpu/
/usr/lib/opencpu/scripts/updatecran.sh 1> `date '+/var/log/opencpu/%Y-%m-%d-cran.log'` 2> `date '+/var/log/opencpu/%Y-%m-%d-cran-warnings.log'`

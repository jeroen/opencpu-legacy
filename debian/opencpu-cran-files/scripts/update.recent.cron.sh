#!/bin/bash
cd /var/log/opencpu/
/usr/lib/opencpu/scripts/update.recent.sh 1> `date '+/var/log/opencpu/%Y-%m-%d_%H:%M-recent.log'` 2> `date '+/var/log/opencpu/%Y-%m-%d_%H:%M-recent-warnings.log'`

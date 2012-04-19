mkdir -p /usr/lib/opencpu/apps/
rm /usr/lib/opencpu/apps/*
echo "#updated on" `date` >> /usr/lib/opencpu/apps/apps-readme

APPS1=$(find /usr/local/lib/R/site-library/*/opencpu/apps -maxdepth 0 2>/dev/null) 
APPS2=$(find /usr/lib/R/site-library/*/opencpu/apps -maxdepth 0 2>/dev/null)
APPS3=$(find /mnt/export/opencpu-cran-library/*/opencpu/apps -maxdepth 0 2>/dev/null)
APPS4=$(find /mnt/export/opencpu-admin-library/*/opencpu/apps -maxdepth 0 2>/dev/null) 
ALLAPPS="$APPS1 $APPS2 $APPS3 $APPS4"

for APP in $ALLAPPS
do
  APP=$(readlink -f $APP)
  PACKAGE=$(basename $(dirname $(dirname $APP)))
  echo "Aliasing /apps/$PACKAGE to location $APP"
  ln -s $APP /usr/lib/opencpu/apps/$PACKAGE
done

python -c 'import os, json; print json.dumps(os.listdir("/usr/lib/opencpu/apps/"))' > /usr/lib/opencpu/apps/index.json

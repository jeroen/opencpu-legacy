rm -Rf /usr/lib/opencpu/userapps/*
mkdir -p /usr/lib/opencpu/userapps

ALLAPPS=$(find /mnt/export/store/user/*/*/opencpu/apps -maxdepth 0 2>/dev/null) 

for APP in $ALLAPPS
do
  APP=$(readlink -f $APP)
  PACKAGE=$(basename $(dirname $(dirname $APP)))
  USERNAME=$(basename $(dirname $(dirname $(dirname $APP))))
  echo "Aliasing /userapps/$USERNAME/$PACKAGE to location $APP"
  mkdir -p /usr/lib/opencpu/userapps/$USERNAME
  ln -s $APP /usr/lib/opencpu/userapps/$USERNAME/$PACKAGE
  python -c 'import os, json; print json.dumps(os.listdir("/usr/lib/opencpu/userapps/'$USERNAME'"))' > /usr/lib/opencpu/userapps/$USERNAME/index.json
done

ln -s /usr/lib/opencpu/apps /usr/lib/opencpu/userapps/opencpu
python -c 'import os, json; print json.dumps(os.listdir("/usr/lib/opencpu/userapps/"))' > /usr/lib/opencpu/userapps/index.json
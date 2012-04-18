rm -Rf /usr/lib/opencpu/userapps/*

ALLAPPS=$(find /mnt/export/store/user/*/*/opencpu/apps -maxdepth 0 2>/dev/null) 

for APP in $ALLAPPS
do
  APP=$(readlink -f $APP)
  PACKAGE=$(basename $(dirname $(dirname $APP)))
  USER=$(basename $(dirname $(dirname $(dirname $APP))))
  echo "Aliasing /userapps/$USER/$PACKAGE to location $APP"
  mkdir -p /usr/lib/opencpu/userapps/$USER
  ln -s $APP /usr/lib/opencpu/userapps/$USER/$PACKAGE
done


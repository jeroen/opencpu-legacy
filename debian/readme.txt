#to build:

cd ..
cp -Rf opencpu.encode /tmp/
cd /tmp/opencpu.encode
debuild
dput ppa:jeroenooms/opencpu opencpu.encode*.changes

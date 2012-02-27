echo "#updated on" `date` > /etc/apache2/sites-available/opencpu-sites

ALIASES=`find /usr/local/lib/R/site-library/*/www -maxdepth 1 -mindepth 1`
ALIASES2=`find /usr/lib/R/site-library/*/www -maxdepth 1 -mindepth 1`
ALLALIASES="$ALIASES $ALIASES2"

for ALIAS in $ALLALIASES
do
  ALIAS=`readlink -f $ALIAS`
  echo "Aliasing /${ALIAS##*/} to location $ALIAS"
  echo "Alias /${ALIAS##*/} $ALIAS" >> /etc/apache2/sites-available/opencpu-sites
done

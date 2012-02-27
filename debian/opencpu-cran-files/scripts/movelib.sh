# Move libraries to /mnt
# We check if libraries have already been moved.

#confirm
while true; do
    read -p "Are you sure you want to move the cran library to /mnt/export ?" yn
    case $yn in
        [Yy]* ) echo "continuing..."; break;;
        [Nn]* ) echo "exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if ! [ -h /usr/lib/R/site-library ];
then	
	#move site library #1
	mv /usr/lib/R/site-library /mnt/export/site-library
	ln -s /mnt/export/site-library /usr/lib/R/site-library
else
	echo "/usr/lib/R/site-library was already a symbolic link. Probably already moved. Not moving".
fi

if ! [ -h /usr/local/lib/R/site-library ];
then		
	#move site library #2
	mv /usr/local/lib/R/site-library /mnt/export/local-site-library
	ln -s /mnt/export/local-site-library /usr/local/lib/R/site-library
else
	echo "/usr/local/lib/R/site-library was already a symbolic link. Not moving".	
fi

echo "Done! CRAN library is now in /mnt/export."
echo "Symbolic links were created to from the old to the new location."
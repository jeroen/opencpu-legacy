# TODO: Add comment
# 
# Author: jeroen
###############################################################################


storefile <- function(mytempfile, where="/tmp/"){

	STOREDIR <- config("storedir");	
	MAXSIZE <- config("max.storesize");
	SUBSTRING <- config("key.length");
	
	if(file.info(mytempfile)$size > MAXSIZE) {
		stop("The file or object you are trying to store is larger than 10MB.")
	}
	
	#calculate hash and store
	filehash <- hashme(mytempfile);
	filehash <- substring(filehash, 0, SUBSTRING);
	filehash <- paste("x", filehash, sep="");
	storelocation <- paste(where, filehash, sep="");
	newfilename <- paste(STOREDIR, storelocation, sep="");
	
	#first try rename, otherwise copy:
	success <- isTRUE(file.rename(mytempfile, newfilename) || file.copy(mytempfile, newfilename, overwrite=TRUE));
	if(!success) stop("Failed to copy file to store: ", newfilename);	
	
	#file.copy(returndata$filename, newfilename, overwrite=T);
	return(storelocation);		
}

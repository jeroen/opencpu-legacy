storebinaryfile <- function(myoldfile){
	rawstream <- readBin(myoldfile, "raw", n=file.info(myoldfile)$size);
	attr(rawstream, "filename") <- myoldfile;
	return(storeobject(rawstream));	
}
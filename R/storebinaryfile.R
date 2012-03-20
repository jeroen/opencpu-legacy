storebinaryfile <- function(myoldfile, contenttype){
	if(!file.exists(myoldfile)){
		stop("File ", myoldfile, " not found.")
	}	
	
	if(isTRUE(file.info(myoldfile)$isdir)){
		mynewfile <- paste(myoldfile, ".bin.tgz", sep="");	
		tar(mynewfile, myoldfile, compression="gzip", tar="internal");
		close(file(mynewfile));
		if(!file.exists(mynewfile)){
			stop("Failed to tar dir: ", myoldfile);
		}
		return(storebinaryfile(mynewfile, contenttype="application/x-tar-gz"));
	} else {	
		rawstream <- readBin(myoldfile, "raw", n=file.info(myoldfile)$size);
		attr(rawstream, "filename") <- myoldfile;
		if(!missing(contenttype)){
			attr(rawstream, "contenttype") <- contenttype;
		}
		return(storeobject(rawstream));
	}
}
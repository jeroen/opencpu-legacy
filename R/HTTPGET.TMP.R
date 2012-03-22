HTTPGET.TMP <- function(uri, fnargs){

	objectkey <- uri[1];
	Routput <- uri[2];	

	tmpdir <- paste(config("storedir"), "/tmp", sep="");	
	
	# /R/tmp	
	if(is.na(objectkey)){
		allfiles <- list.files(tmpdir);
		return(object2jsonfile(list.files(tmpdir), fnargs));
	}
	
	# /R/tmp/x94bd82c90d
	if(is.na(Routput)){
		objectfile <- paste(tmpdir, "/", objectkey, sep="");
		if(file.exists(objectfile)){
			return(object2jsonfile(outputformats, fnargs));			
		} else {
			stop("Object not found: /tmp/", objectkey)
		}
	} 	
	
	# /R/tmp/x94bd82c90d/json
	object <- loadFromFileStore    (objectkey);
	return(renderobject(object, Routput, fnargs));
}
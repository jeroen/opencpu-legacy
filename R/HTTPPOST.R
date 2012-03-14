HTTPPOST <- function(uri, fnargs, files = NULL){
	
	#Parse arguments
	if(length(fnargs) > 0){

		#Check for empty arguments
		emptyargs <- sapply(fnargs, is.null);
		if(any(emptyargs)){
			stop("Empty arguments: ", paste(names(fnargs)[which(sapply(fnargs, is.null))], collapse=", "))
		}

		#check for illegal code injection
		if(any(substr(names(fnargs),1,1) == "#")){
			stop("argument names are not allowed to start with a #");
		}		
		
		#delete filenames from the fnargs variable
		fnargs[names(files)] <- NULL;
		
		#parse HTTP arguments
		fnargs <- lapply(fnargs, tryParse);

		#parse files
		if(length(files) > 0){
			fnargs <- parseFiles(fnargs, files);	
		}
		
		#evaluate metaparameters
		metaparams <- sapply(fnargs, is.expression) & grepl("^!", names(fnargs));
		if(sum(metaparams) > 0){
			fnargs[metaparams] <- lapply(fnargs[metaparams], eval);
		}
		
		#check for a seed (should probably move this to the individual rendering functions)
		if(!is.null(fnargs[["!seed"]])){
			set.seed(fnargs[["!seed"]]);
			fnargs[["!seed"]] <- NULL;
		}
	}	
	
	#split uri
	rootdir <- uri[1];
	taildir <- uri[-1];
	
	#dispatch to rootdir
	returndata <- switch(rootdir,
		pub = HTTPPOST.PUB(taildir, fnargs),
		tmp = HTTPPOST.TMP(taildir, fnargs),
		user = HTTPPOST.USER(taildir, fnargs),
		call = HTTPPOST.PUB(taildir, fnargs), #LEGACY, DEPRICATED!
		stop("Unknown HTTP POST rootdir: ", rootdir)
	);
	
	#add some headers
	returndata$cache <- config("cache.call");
	
	#return the list with content and type and status
	return(returndata);	
}
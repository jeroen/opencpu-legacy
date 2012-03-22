closure <- function(body, enclosed = vector(), ...){
	stopifnot(!missing(body));
	body <- match.call()$body
	otherargs <- as.list(match.call())[-c(1:3)];
	myfunction <- as.function(c(otherargs, body));
	
	if(length(enclosed) > 0){
		preobjects <- lapply(as.list(enclosed), getObject);
		names(preobjects) <- unlist(lapply(strsplit(enclosed, "/"), tail, 1));
		myenv <- as.environment(preobjects);
		parent.env(myenv) <- globalenv();
		environment(myfunction) <- myenv;
	}
	
	return(myfunction);
}

#this is a bit hacky, duplicates some stuff from tryParse
getObject <- function(string){
	
	#if string starts with / assume a local file
	if(substr(string, 1, 1) == "/"){
		myfile <- tempfile();
		download.file(paste("http://localhost/R/store", string,"/rds", sep=""), myfile);
		return(readRDS(myfile));
	}		
	
	#check if it looks like a UUID
	myregex <- "^x[a-f0-9]{10}$"
	if(length(grep(myregex, string) > 0)){
		return(loadFromFileStore    (string));
	}	
	
	#check of the object exists
	if(exists(string)){
		return(get(string))
	}
	
	stop("Object ", string, " not found.")
}

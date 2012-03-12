renderobject <- function(object, Routput, fnargs){

	#block 'save' for GET
	if(Routput == "save"){
		stop("Output type /save cannot be used with method GET.")
	}

	#we evaluate the meta parameters.
	if(length(fnargs) > 0){
		
		#check for illegal code injection
		if(any(substr(names(fnargs),1,1) == "#")){
			stop("arguments are not allowed to start with a #");
		}
		
		#parse HTTP arguments and evaluate
		fnargs <- lapply(fnargs, tryParse, disable.eval=TRUE);		

		#check for a seed
		if(!is.null(fnargs[["!seed"]])){
			set.seed(fnargs[["!seed"]]);
			fnargs[["!seed"]] <- NULL;
		}
	}
	
	#add the function as an argument		
	fnargs[["#dofn"]] <- identity;
	
	#load the object from the store
	fnargs[["x"]] <- object;	
	
	#perform the actual request
	returndata <- callfunction(fnargs, Routput);
	
	#add metadata
	returndata$cache <- config("cache.store");
	returndata$status <- 200;
	
	#return the list with content and type and status
	return(returndata);
}
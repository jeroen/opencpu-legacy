HTTPPOST.TMP <- function(uri, fnargs){
	Robject <- uri[1];
	Routput <- uri[2]
	
	if(is.na(Robject)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}
	
	if(is.na(Routput)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}	
	
	#Check whitelist
	if(any(config("whitelist") != FALSE)){
		stop("Whitelist is not set to false in config. Therefore executing tmp functions is disabled.")
	}	
	
	RPC.FN <- loadFromStore(Robject);
	
	#Test for function. Extend later.
	if(!is.function(RPC.FN)){
		stop("The object that was specified is not a function, script or reproducible document.")	
	}	
	
	#Add it to fnargs
	fnargs[["#dofn"]] <- RPC.FN;
	
	#call the output handler
	return(callfunction(fnargs, Routput));	
	
}

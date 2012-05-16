HTTPPOST.TMP <- function(uri, fnargs){
	Robject <- uri[1];
	Routput <- uri[2]
	
	if(is.na(Robject)) {
		stop('Invalid HTTP POST. No object or output format specified. Please use /R/tmp/x1234567890/someformat');
	}
	
	if(is.na(Routput)) {
		stop('Invalid HTTP POST. No output format specified. Please use /R/tmp/x1234567890/someformat');
	}	
	
	#Check whitelist
	if(any(config("whitelist") != FALSE)){
		stop("Whitelist is not set to false in config. Therefore executing tmp functions is disabled.")
	}	
	
	RPC.FN <- loadFromFileStore(Robject);
	
	#Test for function. Extend later.
	if(!is.function(RPC.FN)){
		stop("The object that was specified is not a function, script or reproducible document.")	
	}	
	
	#Add it to fnargs
	fnargs[["#dofn"]] <- RPC.FN;
	
	#call the output handler
	return(callfunction(fnargs, Routput));	
	
}

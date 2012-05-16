HTTPPOST.PUB <- function(uri, fnargs){
	Rpackage <- uri[1];
	Robject  <- uri[2];
	Routput  <- uri[3];

	if(is.na(Rpackage)) {
		stop('Invalid HTTP POST URI. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}
	
	if(is.na(Robject)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}
	
	if(is.na(Routput)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}	
	
	#Check whitelist
	if(any(config("whitelist") != FALSE)){
		if(!Rpackage %in% config("whitelist")){
			stop("Package: ", Rpackage, " is not in the config whitelist.")
		}
	}	
	
	#RPC.FN <- loadFromPackage(Rpackage, Robject);
	RPC.FN <- getExportedValue(Rpackage, Robject);
	
	#Test for function. Extend later.
	if(!is.function(RPC.FN)){
		stop("The object that was specified is not a function, script or reproducible document.")	
	}	
	
	#Note: in R 2.15 we need to attach the namespace to make any dependencies work. This seems like a bug in R.
	library(Rpackage, character.only=TRUE);
	
	#Add it to fnargs
	#fnargs[["#dofn"]] <- RPC.FN;
	fnargs[["#dofn"]] <- paste(Rpackage, Robject, sep="::")
	
	#call the output handler
	return(callfunction(fnargs, Routput));	

}


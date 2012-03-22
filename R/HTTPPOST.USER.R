HTTPPOST.USER <- function(uri, fnargs){
	
	Rusername <- uri[1];
	Rpackage  <- uri[2];
	Robject   <- uri[3];
	Routput   <- uri[4];
	
	#POST /R/user
	if(is.na(Rusername)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}
	
	#POST /R/user/jeroenooms
	if(is.na(Rpackage)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}	
	
	#POST /R/user/jeroenooms/mypackage
	if(is.na(Robject)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}	
	
	#POST /R/user/jeroenooms/mypackage/myfunction
	if(is.na(Routput)) {
		stop('Invalid HTTP POST. Please use /R/pub/somepackage/somefunction/someformat?foo="bar"');
	}		
		
	#Check whitelist
	if(any(config("whitelist") != FALSE)){
		stop("Whitelist is not set to false in config. Therefore executing user functions is disabled.")
	}	
		
	#paths
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	packagedir <- paste(userdir, Rpackage, sep="/");
	
	#Test if store exists
	validateUserStore(Rusername, Rpackage);
	
	#POST /R/user/jeroenooms/mypackage/json 
	if(isTRUE(file.info(packagedir)$isdir)){

		#Unload namespace if another version of the same package is pre-loaded
		envirname <- paste("package", Rpackage, sep=":");
		if(envirname %in% search()){
			unloadNamespace(Rpackage);
		}			
		
		#load the package
		mynamespace <- loadNamespace(Rpackage, lib.loc=userdir);
		
		#We also attach the namespace to resolve within-userdir dependences
		setLibPaths(c(userdir, .libPaths()));
		
		#Get the object
		RPC.FN <- getExportedValue(Rpackage, Robject);
	} else {
		#Get the object
		RPC.FN <- loadFromUserStore(Rusername, Rpackage, Robject, attach=TRUE);
	}
	
	#Test for function. 
	if(!is.function(RPC.FN)){
		stop("The object that was specified is not a function, script or reproducible document.")	
	}	
	
	#Add it to fnargs
	fnargs[["#dofn"]] <- RPC.FN;
	
	#call the output handler
	return(callfunction(fnargs, Routput));	
}

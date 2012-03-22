HTTPDELETE.HOME <- function(uri, fnargs, userinfo){

	#input
	Rpackage <- uri[1];
	Robject  <- uri[2];
	Rtoolong  <- uri[3];
	
	#user info
	Rusername <- userinfo$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	packagedir <- paste(userdir, Rpackage, sep="/");

	#some uri validation:
	if(is.na(Rpackage) || !is.na(Rtoolong)){
		stop("Invalid URI. Use PUT /home/mypackage or PUT /home/mypackage/someobject.")
	}

	#check for arguments:
	if(length(fnargs) > 0){
		stop("Delete a store does not have any arguments. (", names(fnargs), ")")
	}	
	
	#DELETE /home/mypackage
	if(is.na(Robject)){
		validateUserStore(Rusername, Rpackage);
		
		#remove the package or store
		file.rename(packagedir, tempfile());
		return(object2jsonfile("/home"));
	}

	#DELETE /home/mypackage/someobjectb65c83ab	
	validateUserStore(Rusername, Rpackage, "store");
	
	#Remove the object from the store.
	removeFromUserStore(Rusername, Rpackage, Robject);
	
	#return
	return(object2jsonfile(paste("/R/user", Rusername, Rpackage, sep="/")));
}
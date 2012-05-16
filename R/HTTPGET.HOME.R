HTTPGET.HOME <- function(uri, fnargs, userinfo){

	Rpackage <- uri[1];
	Robject <- uri[2];
	Rtoolong <- uri[3];
	
	if(!is.na(Rtoolong) || !is.na(Rtoolong)){
		stop("Invalid URL. Use GET /home/somepackage or GET/home/somepackage/myobject.\n\nTo render or compute, use /R/user/yourname/somepackage.");
	}
	
	#GET /home
	Rusername <- userinfo$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	packagedir <- paste(userdir, Rpackage, sep="/")
	
	if(is.na(Rpackage)){
		validateUser(Rusername);
		return(object2jsonfile(list.files(userdir), fnargs))
	}
	
	validateUserStore(Rusername, Rpackage);
	
	# GET /home/ggplot2
	if(is.na(Robject)){	
		#File is a workspace	
		if(!isTRUE(file.info(packagedir)$isdir)){
			return(list(
				filename = packagedir, 
				type = "application/octet-stream",
				disposition = paste(Rpackage, "Rdata", sep=".")
			));
		} else {	
			#File is a directory (package)
			descriptionfile <- paste(packagedir, "DESCRIPTION", sep="/");
			if(!file.exists(descriptionfile)){
				stop("Directory ", Rpackage, " was found, but had no DESCRIPTION file.");
			}	
			return(list(
				filename = descriptionfile, 
				type = "text/plain"
			));
		}
	}
	
	# GET /home/somestore/myobject
	# must be a store (not a package)
	validateUserStore(Rusername, Rpackage, "store")

	#get the object
	myobject <- loadFromUserStore(Rusername, Rpackage, Robject);
	myfile <- tempfile();
	saveRDS(myobject, myfile);
	
	#return the object
	return(list(
		filename = myfile, 
		type = "application/octet-stream",
		disposition = paste(Robject, "rds", sep=".")
	));	
}
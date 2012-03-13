HTTPGET.HOME <- function(uri, fnargs){
	Rusername <- uri[1];
	Rpackage  <- uri[2];
	Robject   <- uri[3];
	Routput   <- uri[4];
	
	#GET /R/home
	homedir <- paste(config("storedir"), "home", sep="/");
	if(is.na(Rusername)){
		return(object2jsonfile(list.files(homedir), fnargs))
	}
	
	#GET /R/home/jeroenooms
	userdir <- paste(homedir, Rusername, sep="/");
	if(is.na(Rpackage)){
		if(!file.exists(userdir)){
			stop("User dir /home/", Rusername, " not found.")
		}
		return(object2jsonfile(list.files(userdir), fnargs))
	}
	
	#Test if directory exists
	packagedir <- paste(userdir, Rpackage, sep="/");
	if(!file.exists(packagedir)){
		stop("Package /home/", Rusername, "/", Rpackage, " not found.");
	}
	
	#Unload namespace if another version of the same package is pre-loaded
	envirname <- paste("package", Rpackage, sep=":");
	if(envirname %in% search()){
		unloadNamespace(Rpackage);
	}	

	#Here we need the package (or store)
	mynamespace <- loadNamespace(Rpackage, lib.loc=userdir);

	#We also attach the namespace to resolve within-user dependences
	.libPaths(userdir);
	
	#GET /R/home/jeroenooms/somepackage
	if(is.na(Robject)){
		allobjects <- getNamespaceExports(mynamespace);
		return(object2jsonfile(allobjects, fnargs));
	} 	
	
	#GET /R/home/jeroenooms/somepackage/object
	if(is.na(Routput)){
		object <- getExportedValue(Rpackage, Robject);
		return(object2jsonfile(outputformats, fnargs));	
	}
	
	object <- getExportedValue(Rpackage, Robject);
	return(renderobject(object, Routput, fnargs));	
}
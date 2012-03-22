HTTPGET.USER <- function(uri, fnargs){
	Rusername <- uri[1];
	Rpackage  <- uri[2];
	Robject   <- uri[3];
	Routput   <- uri[4];
	
	#GET /R/user
	homedir <- paste(config("storedir"), "user", sep="/");
	if(is.na(Rusername)){
		return(object2jsonfile(list.files(homedir), fnargs))
	}
	
	#GET /R/user/jeroenooms
	userdir <- paste(homedir, Rusername, sep="/");
	packagedir <- paste(userdir, Rpackage, sep="/")
	if(is.na(Rpackage)){
		validateUser(Rusername);
		return(object2jsonfile(list.files(userdir), fnargs))
	}
	
	#Test if directory exists
	validateUserStore(Rusername, Rpackage)
	
	#Package or store?
	if(isTRUE(file.info(packagedir)$isdir)){
		
		#Unload namespace if another version of the same package is pre-loaded
		envirname <- paste("package", Rpackage, sep=":");
		if(envirname %in% search()){
			unloadNamespace(Rpackage);
		}	
	
		#Here we need the package (or store)
		mynamespace <- loadNamespace(Rpackage, lib.loc=userdir);
	
		#We also attach the namespace to resolve within-user dependences
		.libPaths(userdir);
		
		#GET /R/user/jeroenooms/somepackage
		if(is.na(Robject)){
			allobjects <- getNamespaceExports(mynamespace);
			return(object2jsonfile(allobjects, fnargs));
		} 	
		
		#GET /R/user/jeroenooms/somepackage/object
		if(is.na(Routput)){
			object <- getExportedValue(Rpackage, Robject);
			return(object2jsonfile(outputformats, fnargs));	
		}
		
		object <- getExportedValue(Rpackage, Robject);
		return(renderobject(object, Routput, fnargs));	
	} else {

		#GET /R/user/jeroenooms/somestore
		if(is.na(Robject)){
			myenv <- new.env();
			load(packagedir, envir=myenv)
			allobjects <- ls(myenv);
			return(object2jsonfile(allobjects, fnargs));
		} 		
		
		#load the object
		object <- loadFromUserStore(Rusername, Rpackage, Robject)		
		
		#GET /R/user/jeroenooms/somestore/someobject
		if(is.na(Routput)){
			return(object2jsonfile(outputformats, fnargs));	
		}		
		
		#GET /R/user/jeroenooms/somestore/someobject/json
		return(renderobject(object, Routput, fnargs));
	}
}
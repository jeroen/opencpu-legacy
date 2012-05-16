HTTPPUT.HOME <- function(uri, fnargs, files, userinfo){

	#input
	Rpackage <- uri[1];
	Robject  <- uri[2];
	Rtoolong  <- uri[3];
	object <- fnargs$object;
	
	#user info
	Rusername <- userinfo$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	packagedir <- paste(userdir, Rpackage, sep="/");

	#some uri validation
	if(!is.na(Rtoolong)){
		stop("Invalid URI. Use PUT /home/mypackage or PUT /home/mypackage/someobject.")
	}
	
	#PUT /home
	if(is.na(Rpackage)){
		stop("Your url is too invalid. Use PUT /home/somepackage or PUT /home/somepackage/myobject.");
	}
	
	#PUT /home/mypackage
	if(is.na(Robject)){
		if(file.exists(packagedir)){
			stop("There already is a package or store named: ", Rpackage);
		}

		#check if PUT contains a package or workspace argument
		packagefile   <- fnargs$package;
		workspacefile <- fnargs$workspace;
		
		#in case a package is being posted
		if(!is.null(packagefile)){
			mytemp <- tempfile();
			download.file(paste("http://127.0.0.1/R/tmp/", packagefile, "/bin", sep=""), destfile=mytemp);
			if(!file.exists(mytemp)){
				stop("Download failed.")
			}
			untar(mytemp);	
			
			#check if the package was in the tgzfile that we just extracted in our working dir
			tmppackagedir <- paste(getwd(), Rpackage, sep="/");
			descriptionfile <- paste(tmppackagedir, "DESCRIPTION", sep="/");
			
			if(!file.exists(tmppackagedir)){
				stop("The package file did not contain a directory: ", Rpackage);
			}	
			
			if(!file.exists(descriptionfile)){
				stop("Directory ", Rpackage, " was found, but had no DESCRIPTION file. Probably not a valid R package.");
			}
			
			#move the package
			tryrename <- file.rename(tmppackagedir, packagedir)
			if(!isTRUE(tryrename)){
				stop("Moving package to userdir failed.")
			}			
			
		} else if(!is.null(workspacefile)){
			mytemp <- tempfile();
			download.file(paste("http://127.0.0.1/R/tmp/", workspacefile, "/bin", sep=""), destfile=mytemp);
			if(!file.exists(mytemp)){
				stop("Download failed.")
			}	
			myenv <- new.env();
			load(mytemp, env=myenv);
			save(list=ls(myenv), envir=myenv, file=packagedir);
		} else {
			#create an empty workspace
			save(file=packagedir);
		}
		return(object2jsonfile(paste("/R/user", Rusername, Rpackage, sep="/")));
	}

	
	#PUT /home/mypackage/someobject?object=x83b65c83ab	
	if(isTRUE(file.info(packagedir)$isdir)){
		stop("Namespace for ", Rpackage, " exists, but it is a package, not a store. You can only PUT objects in a store.");
	}	
	
	#we need an object to put
	if(is.null(object)){
		stop("Argument 'object' is required to PUT an object.")
	}	
	
	#get the object
	if("object" %in% names(files)){
		loadedobject <- readRDS(files$object$tmp_name);	
	} else {
		#load the object into store
		loadedobject <- loadFromFileStore(object);
	}
	
	#add the object to the store
	addToUserStore(Rusername, Rpackage, Robject, loadedobject)
	
	#return
	return(object2jsonfile(paste("/R/user", Rusername, Rpackage, Robject, sep="/")));
}
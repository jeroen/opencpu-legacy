HTTPPOST.HOME <- function(uri, fnargs, files, userinfo){

	Rpackage <- uri[1];
	Rtoolong <- uri[2];
	tgzfile  <- fnargs$tgzfile;
	
	#POST /home/mypackage?zipfile=x83cd92a9cf	
	if(is.na(Rpackage) || !is.na(Rtoolong)){
		stop("Your url is too invalid. Use /home/somepackage to GET, POST, PUT and DELETE packages. Use /R/user/yourname/somepackage for computing.");
	}
	
	if(is.null(tgzfile)){
		stop("Argument 'zipfile' is required.")
	}
	
	#User info
	Rusername <- userinfo$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	
	#Download the package
	mytemp <- tempfile();
	download.file(paste("http://127.0.0.1/R/tmp/", tgzfile, "/bin", sep=""), destfile=mytemp);
	if(!file.exists(mytemp)){
		stop("Download failed.")
	}
	untar(mytemp);
	
	#check if the package was in the tgzfile
	packagedir <- paste(getwd(), Rpackage, sep="/");
	descriptionfile <- paste(packagedir, "DESCRIPTION", sep="/");
	
	if(!file.exists(packagedir)){
		stop("The tgzfile did not contain a directory: ", Rpackage);
	}
	
	if(!file.exists(descriptionfile)){
		stop("Directory ", Rpackage, " was found, but had no DESCRIPTION file.");
	}	
	
	#Finally, copy the package to the users home dir
	newdir <- paste(userdir, Rpackage, sep="/");
	if(file.exits(newdir)){
		unlink(newdir, recursive=TRUE);
	}
	
	#move the package
	tryrename <- file.rename(packagedir, newdir)
	if(!isTRUE(tryrename)){
		stop("Moving package to userdir failed.")
	}
	
	return(object2jsonfile(paste("/R/user", Rusername, Rpackage, sep="/")));
}
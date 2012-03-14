HTTPGET.HOME <- function(uri, fnargs, userinfo){

	Rpackage <- uri[1];
	Robject <- uri[2];
	Rtoolong <- uri[3];
	
	if(!is.na(Rtoolong) || !is.na(Robject)){
		stop("Your url is too invalid. Use /home/somepackage to GET, PUT and DELETE packages. Use /R/user/yourname/somepackage for computing.");
	}
	
	#GET /home
	Rusername <- userinfo$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	
	if(is.na(Rpackage)){
		if(!file.exists(userdir)){
			stop("User dir /user/", Rusername, " not found.")
		}
		return(object2jsonfile(list.files(userdir), fnargs))
	}
	
	# GET /home/ggplot2
	packagedir <- paste(userdir, Rpackage, sep="/");
	descriptionfile <- paste(packagedir, "DESCRIPTION", sep="/");
	
	if(!file.exists(packagedir)){
		stop("Package :", Rpackage, " not found.");
	}
	
	if(!file.exists(descriptionfile)){
		stop("Directory ", Rpackage, " was found, but had no DESCRIPTION file.");
	}	
	
	if(is.na(Robject)){
		return(list(
			filename = descriptionfile, 
			type = "text/plain"
		));
	}
}
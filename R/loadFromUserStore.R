loadFromUserStore <- function(Rusername, store, Robject, attachstore=FALSE){
	
	#path
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	storefile <- paste(userdir, store, sep="/");
	
	#load up an environment
	myenv <- new.env();
	load(storefile, envir=myenv);		
	
	#check if it exists	
	if(!(Robject %in% ls(myenv))){
		stop("Object: ", Robject, " not found in /R/user/", Rusername, "/", store);
	}
	
	#read the object
	object <- get(Robject, envir=myenv);
	object <- fixobject(object);
	
	#attach the rest of the store
	if(attachstore){
		attach(myenv, name=paste("store:", store, sep=""));
	}
	
	#return
	return(object);
}
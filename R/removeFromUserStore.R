removeFromUserStore <- function(Rusername, store, Robject){

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
	
	#remove the object
	remove(list=Robject, envir=myenv);
	
	#save the new store
	newstore <- tempfile();
	save(file=newstore, list=ls(myenv), envir=myenv);
	
	#move the old store
	file.rename(storefile, tempfile());
	
	#replace it with the new store
	file.rename(newstore, storefile);
}
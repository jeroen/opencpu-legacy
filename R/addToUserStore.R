addToUserStore <- function(Rusername, store, Robjectname, Robjectvalue){
	
	#path
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	storefile <- paste(userdir, store, sep="/");
	
	#load up an environment
	myenv <- new.env();
	load(storefile, envir=myenv);		
	
	#check if it exists	
	if(Robjectname %in% ls(myenv)){
		stop("Object: ", Robjectname, " already exists in /R/user/", Rusername, "/", store);
	}
	
	#add the object
	assign(Robjectname, Robjectvalue, envir=myenv);	
	
	#save the new store
	newstore <- tempfile();
	save(file=newstore, list=ls(myenv), envir=myenv);
	
	#move the old store
	file.rename(storefile, tempfile());
	
	#replace it with the new store
	file.rename(newstore, storefile);
}
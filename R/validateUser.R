validateUser <- function(Rusername){
	
	#paths
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	
	#check if userdir
	if(!file.exists(userdir)){
		stop("No store or package found: /R/user/", Rusername)
	}
	
	#return
	return();
}
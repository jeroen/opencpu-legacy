validateUserStore <- function(Rusername, store, type=c("package", "store")){
	
	#paths
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");
	storefile <- paste(userdir, store, sep="/");
	
	#check if userdir
	if(!file.exists(userdir)){
		stop("No store or package found: /R/user/", Rusername)
	}
	
	#check if userdir
	if(!file.exists(storefile)){
		stop("No store or package found: /R/user/", Rusername, "/", store)
	}
	
	#check if it is a dir (package) or file (store)
	if(isTRUE(file.info(storefile)$isdir)){
		if("package" %in% type){
			#valid package
			return();
		} else {
			stop(store, " is a store file, not a package.")
		}
	} else {
		if("store" %in% type){
			#valid store
			return();
		} else {
			stop(store, " is a directory, not a store file.")
		}
	}
}
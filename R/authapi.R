authapi <- function(uri, fnargs){
	
	if(!isTRUE(config("enable.home"))){
		stop("enable.home is not enabled on this server.")
	}	

	#test for valid endpoint
	authfun <- uri[1];
	if(is.na(authfun)){
		stop("Invalid endpoint: /auth. Please use /auth/login.");
	}
	
	#eg /auth/login
	returndata <- switch(authfun,
		login = login(fnargs),
		logout = logout(),
		stop("Invalid authentication endpoint: ", authfun)
	);
	
	#disable caching!
	returndata$cache = FALSE;
	
	#return
	return(returndata);	

}
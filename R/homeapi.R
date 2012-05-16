homeapi <- function(HTTPMETHOD, URI, FNARGS, NEWFILESVAR, ACCESS_TOKEN){
	
	if(!isTRUE(config("enable.home"))){
		stop("enable.home is not enabled on this server.")
	}
	
	#We need an access token
	if(is.null(ACCESS_TOKEN) || ACCESS_TOKEN == ""){
		stop("Not logged in. Authenticate through /auth/login")
	}
	
	#All calls under /home need an active github session.
	USERINFO <- getUserInfo(ACCESS_TOKEN);
	
	returndata <- switch(HTTPMETHOD,
		GET = HTTPGET.HOME(URI, FNARGS, USERINFO),
		#POST = HTTPPOST.HOME(URI, FNARGS, NEWFILESVAR, USERINFO),
		PUT = HTTPPUT.HOME(URI, FNARGS, NEWFILESVAR, USERINFO),
		DELETE = HTTPDELETE.HOME(URI, FNARGS, USERINFO),
		stop("Unknown http method for /home: ", HTTPMETHOD)			
	);
	
	#disable caching!
	returndata$cache = FALSE;
	
	#return
	return(returndata);
}

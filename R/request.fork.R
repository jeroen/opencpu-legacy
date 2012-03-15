request.fork <- function(API){

	#HTTP Method:
	HTTPMETHOD <- SERVER$method
	
	#Files and arguments
	NEWFILESVAR <- FILES
	FNARGS <- switch(SERVER$method, POST = POST, PUT = POST, GET);
	
	#In case of no arguments
	if(is.null(FNARGS)){
		FNARGS <- list();
	}
	
	#Check for the token cookie
	ACCESS_TOKEN <- COOKIES$access_token
	
	#Get uri endpoint (without /R)
	URI <- strsplit(substring(SERVER$path_info, 2),"/")[[1]];
	
	#dispatch based on method
	myfork <- mcparallel(
		{
			#Rapache shouldn't be required anymore here.
			detach("rapache");
			eval(detach("package:opencpu.server"), globalenv());
			
			#Invoke method:
			switch(API,
				pubapi = pubapi(HTTPMETHOD, URI, FNARGS, NEWFILESVAR),
				homeapi = homeapi(HTTPMETHOD, URI, FNARGS, NEWFILESVAR, ACCESS_TOKEN),
				authapi = authapi(URI, FNARGS),
				stop("Invalid API: ", API)
			);
		}, 
		silent=TRUE
	);
	
	#wait max n seconds for a result.
	myresult <- mccollect(myfork, wait=FALSE, timeout=config("job.timeout"))[[1]];
	
	#kill fork after collect has returned
	pskill(myfork$pid, SIGKILL);	
	
	#clean up:
	mccollect(myfork, wait=TRUE);

	#timeout?
	if(is.null(myresult)){
		stop("R call did not return within ", config("job.timeout"), " seconds. Terminating process.", call.=FALSE);		
	}
	
	#forks don't throw errors themselves
	if(class(myresult) == "try-error"){
		#stop(myresult, call.=FALSE);
		stop(attr(myresult, "condition"));
	}
	
	#send the buffered response
	send.response(myresult);

	#Report back to roothandler
	#After body content has been sent (above) it's too late to change status code.
	#You can only return OK.
	return(OK);
}
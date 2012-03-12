request.fork <- function(){

	#HTTP Method:
	HTTPMETHOD <- SERVER$method
	
	#Files and arguments
	NEWFILESVAR <- FILES
	FNARGS <- switch(SERVER$method, POST = POST, PUT = POST, GET);
	
	#In case of no arguments
	if(is.null(FNARGS)){
		FNARGS <- list();
	}
	
	#Get uri endpoint (without /R)
	URI <- strsplit(substring(SERVER$path_info, 2),"/")[[1]];
	
	#dispatch based on method
	myfork <- mcparallel({
				
		#Rapache shouldn't be required anymore here.
		detach("rapache");
		
		#Invoke method:
		switch(HTTPMETHOD,
			GET = HTTPGET(URI, FNARGS),
			POST = HTTPPOST(URI, FNARGS, NEWFILESVAR),
			stop("Unknown http method: ", HTTPMETHOD)			
		)}, 
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
		stop(myresult, call.=FALSE);
	}
	
	#send the buffered response
	send.response(myresult);

	#report back to roothandler
	return(OK);	
}
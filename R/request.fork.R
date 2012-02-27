request.fork <- function(){

	#Jeffrey says: Don't reference RApache variables in the forked child process.
	assign("NEWFILESVAR", FILES, "OpenCPU");
	assign("fnargs", switch(SERVER$method, POST = POST,	PUT = POST, GET), "OpenCPU");
	
	#little trick to have hashme still available after detach
	assign("hashme", opencpu.server:::hashme, envir=as.environment("package:base"))
	
	#Parse HTTP request
	uri <- SERVER$path_info;
	
	#hack for rapache bug when server runs on custom port:
	if(grepl(":",SERVER$headers_in$Host)){
		uri <- paste(strsplit(uri,"/")[[1]][-2], collapse="/");
	}
	
	#Serve a documentation page at frontpage
	if(uri == "" || uri == "/"){
		uri <- "/frontpage";
	}
	
	#split uri
	uri.split <- strsplit(substring(uri, 2),"/")[[1]];	
	
	#parse R function URI. If it's too short will result in NA's (no error).
	Rwhat <- uri.split[1]; #call or store or help
	Rlocation <- uri.split[2]; #package or store location
	Rfnobj <- uri.split[3];	#function or md5 object key
	Routput <- uri.split[4]; #output format
	
	myfork <- parallel(
		switch(Rwhat,
			call = FUNCTIONhandler(Rlocation, Rfnobj, Routput),
			store = STOREhandler(Rlocation, Rfnobj, Routput),
			frontpage = printFrontpage(),
			help = HELPhandler(Rlocation, Rfnobj, Routput),
			execute = EXECUTEhandler(Rlocation, Rfnobj), #arg names are unfortunate here
			lasterror = lasterror(),
			stop("Unknown location: /", Rwhat)
		), 
		silent=TRUE
	);
	
	#wait max 20 seconds for a result.
	myresult <- collect(myfork, wait=FALSE, timeout=config("job.timeout"))[[1]];
	
	#kill fork after collect has returned
	kill(myfork, SIGKILL);	
	
	#clean up:
	collect(myfork, wait=TRUE);

	#timeout?
	if(is.null(myresult)){
		stop("R call did not return within ", config("job.timeout"), " seconds. Terminating process.", call.=FALSE);		
	}
	
	#forks don't throw errors themselves
	if(class(myresult) == "try-error"){
		stop(myresult, call.=FALSE);
	}
	
	#select output method
	switch(SERVER$method,
		GET = send.GET(myresult),
		POST = send.GET(myresult),
		stop("No send method for method: ", SERVER$method)
	);	

	return(list(status=200));	
}
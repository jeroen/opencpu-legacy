HTTPGET <- function(uri, fnargs){
	
	#Serve a documentation page at frontpage
	if(length(uri) == 0){
		uri <- "frontpage";
	}
	
	#split uri
	rootdir <- uri[1];
	taildir <- uri[-1];
	
	#dispatch to rootdir
	#NOTE: 
	# /call and /store are DEPRECATED
	# Don't use them anymore. They will be removed.
	return(
		switch(rootdir,
			pub = HTTPGET.PUB(taildir, fnargs),
			tmp = HTTPGET.TMP(taildir, fnargs),
			user = HTTPGET.USER(taildir, fnargs),
			call = HTTPPOST(uri, fnargs), #LEGACY DEPRECATED 
			store = HTTPGET(taildir, fnargs), #LEGACY DEPRECATED 
			frontpage = HTTPGET.FRONTPAGE(),
			lasterror = lasterror(),
			stop("Unknown HTTP GET rootdir: ", rootdir)
		)
	);
}
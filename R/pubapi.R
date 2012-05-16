pubapi <- function(HTTPMETHOD, URI, FNARGS, NEWFILESVAR){
	return(
		switch(HTTPMETHOD,
			GET = HTTPGET(URI, FNARGS),
			POST = HTTPPOST(URI, FNARGS, NEWFILESVAR),
			stop("Unknown http method: ", HTTPMETHOD)			
		)
	);
}
	
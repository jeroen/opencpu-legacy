lasterror <- function(){
	e <- readRDS("/tmp/lasterror");
	mytemp <- tempfile();
	writeLines(e$message, mytemp);
	unlink("/tmp/lasterror");
	
	return(
		list(
			filename=mytemp, 
			type="text/plain; charset=UTF8",
			headers=e$headers,
			cookies=e$cookies
		)
	);
}



EXECUTEhandler <- function(typeofexec, Routput){
	
	if( any(is.na(c(typeofexec, Routput))) || any(c(typeofexec, Routput) == "") ){
		stop("Invalid URI: ", SERVER$path_info)
	}	
	
	if(typeofexec == "code"){
		#parse arguments
		if(!"x" %in% names(fnargs)){
			stop("Execute needs parameter: x");
		} else {
			newfnargs <- list();
			newfnargs$x <- paste("{", fnargs$x, "}", sep="");
			assign("fnargs", newfnargs, "OpenCPU");
			FUNCTIONhandler("base", "identity", Routput)
		}
	} else {
		stop("Unknown type of code execution:", typeofexec);
	}
}


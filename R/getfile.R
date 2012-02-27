# TODO: Add comment
# 
# Author: jeroen
###############################################################################


getfile <- function(fnargs){

	mytempfile <- do.call(dogetfile, fnargs);
	
	if(!is.null(attr(mytempfile, "CONTENTTYPE"))){
		CONTENTTYPE <- attr(mytempfile, "CONTENTTYPE");
	} else {
		CONTENTTYPE <- "application/octet-stream";
	}
		
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition=tail(strsplit(mytempfile, "/")[[1]],1)));	
}

dogetfile <- function(`#dofn`, ...){
	
	# The code below works fine. However, hadley's method results in a smaller 'call' object for the 
	# resulting object.
	#
	# e1 <- new.env(parent = .GlobalEnv)
	# output <- eval(get("#dofn")(...), envir=e1);
	
	#build the function call and evaluate expressions at the very last moment.
	fnargs <- as.list(match.call(expand.dots=F)$...);
	argn <- lapply(names(fnargs), as.name);
	names(argn) <- names(fnargs);
	
	#insert expressions into call
	exprargs <- sapply(fnargs, is.expression);
	if(length(exprargs) > 0){
		expressioncalls <- lapply(fnargs[exprargs], "[[", 1);
		argn[names(fnargs[exprargs])] <- expressioncalls;
	}
	
	#call the new function
	call <- as.call(c(list(as.name("#dofn")), argn));
	fnargs <- c(fnargs, list("#dofn" = `#dofn`));

	detach("rapache");
	detach("package:opencpu.server");
	output <- eval(call, fnargs, globalenv());
	
	#check for valid existence.
	if(!file.exists(output)){
		stop("The /R/file/ handler did not return an existing file path.")
	}
	
	#return path to file
	return(output);
}
getascii <- function(fnargs){
	CONTENTTYPE <- "text/plain; charset=UTF8";
	mytempfile <- do.call(dogetascii, fnargs);
	hash <- hashme(mytempfile);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

dogetascii <- function(`#dofn`, ...){
	
	#prepare
	mytempfile <- tempfile();
	
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

	output <- eval(call, fnargs, globalenv());
	
	#write output
	dput(output, file=mytempfile);
	return(mytempfile);	
}

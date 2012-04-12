getprint <- function(fnargs){
	CONTENTTYPE <- "text/plain; charset=UTF8";
	mytempfile <- do.call(dogetprint, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

dogetprint <- function(`#dofn`, `!digits` =  getOption("digits"),  ...){
	
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
	
	#clean up and call
	output <- eval(call, fnargs, globalenv());
	
	#print output
	myprint <- capture.output(print(output, digits=`!digits`));
	
	#write output
	write(myprint, mytempfile);
	return(mytempfile);	
}
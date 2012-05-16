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
	if(is.character(`#dofn`)){
		mycall <- as.call(c(list(parse(text=`#dofn`)[[1]]), argn));
	} else {
		mycall <- as.call(c(list(as.name("FUN")), argn));
		fnargs <- c(fnargs, list("FUN" = `#dofn`));		
	}
	
	#clean up and call
	output <- eval(mycall, fnargs, globalenv());
	
	#print output
	myprint <- capture.output(print(output, digits=`!digits`));
	
	#write output
	write(myprint, mytempfile);
	return(mytempfile);	
}
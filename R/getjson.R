getjson <- function(fnargs){
	CONTENTTYPE <- "application/json; charset=UTF8";
	mytempfile <- do.call(dogetjson, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

dogetjson <- function(`#dofn`, `!digits` =  getOption("digits"), `!pretty`= TRUE, ...){

	#prepare
	mytempfile <- tempfile();
	
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
	if(is.character(`#dofn`)){
		mycall <- as.call(c(list(parse(text=`#dofn`)[[1]]), argn));
	} else {
		mycall <- as.call(c(list(as.name("FUN")), argn));
		fnargs <- c(fnargs, list("FUN" = `#dofn`));		
	}

	#clean up and call
	output <- eval(mycall, fnargs, globalenv());
	
	#write output
	write(opencpu.encode::asJSON(unclass(output), digits=`!digits`, pretty=`!pretty`), mytempfile);
	return(mytempfile);	
}
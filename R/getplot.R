getplot <- function(fnargs){
	mytempfile <- do.call(dogetplot, fnargs);
	return(list(filename = mytempfile, disposition = "myplot.rds"));	
}

dogetplot <- function(`#dofn`, `!printoutput`= TRUE, ...){
	
	#prepare
	mytempfile <- tempfile();
	
	#record a displaylist
	postscript(tempfile());
	par("bg" = "white")
	dev.control(displaylist="enable");
	
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

	output <- eval(call, fnargs, globalenv());

	if(`!printoutput`){
		void <- capture.output(print(output));
	}	

	# load displaylist into variable  
	myplot <- recordPlot();
	dev.off();

	#write output
	saveRDS(myplot, file=mytempfile);
	return(mytempfile)		
}
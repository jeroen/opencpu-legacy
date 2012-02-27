plotpdf <- function(fnargs){
	CONTENTTYPE <- "application/pdf";
	DISPOSITION <- 'plot.pdf'
	
	mytempfile <- do.call(doplotpdf, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition = DISPOSITION));	
}

doplotpdf <- function(`#dofn`, `!width` = 11.69, `!height` = 8.27 , `!paper` = "a4r", `!pointsize` = 12, `!printoutput`= TRUE, ...){
	
	#prepare
	mytempfile <- tempfile();
	pdf(mytempfile, width=`!width`, height=`!height`, paper=`!paper`, pointsize=`!pointsize`);
	
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

	if(`!printoutput`){
		void <- capture.output(print(output));
	}	
	
	#write output
	dev.off();
	return(mytempfile)		
}
gettable <- function(fnargs){
	CONTENTTYPE <- "text/plain; charset=UTF8";
	DISPOSITION <- 'datafile.tab'

	mytempfile <- do.call(dogettable, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition = DISPOSITION));
}

dogettable <- function(`#dofn`, `!quote` = TRUE, `!sep` = "\t", `!eol` = "\n", `!na` = "", `!dec` = ".", `!row.names` = FALSE, `!col.names` = TRUE, ...){
	
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
	call <- as.call(c(list(as.name("#dofn")), argn));
	fnargs <- c(fnargs, list("#dofn" = `#dofn`));

	output <- eval(call, fnargs, globalenv());
	
	#check for dataframe
	if(!is.data.frame(output) && !is.matrix(output)){
		stop("Your call/object did not return a matrix or dataframe. The /table output type should only be used for matrices or dataframes.")
	}	

	#write output
	write.table(output, mytempfile, quote = `!quote`, sep=`!sep`, eol=`!eol`, na=`!na`, dec=`!dec`, row.names=`!row.names`, col.names=`!col.names`);
	return(mytempfile);	
}
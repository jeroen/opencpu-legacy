getcsv <- function(fnargs){
	CONTENTTYPE <- "text/csv; charset=UTF8";
	DISPOSITION <- 'datafile.csv'

	mytempfile <- do.call(dogetcsv, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition = DISPOSITION));
}

dogetcsv <- function(`#dofn`, `!quote` = TRUE, `!sep` = ",", `!eol` = "\n", `!na` = "", `!dec` = ".", `!row.names` = FALSE, `!col.names` = TRUE, ...){
	
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

	output <- eval(mycall, fnargs, globalenv());
	
	#check for dataframe
	if(!is.data.frame(output) && !is.matrix(output)){
		stop("Your call/object did not return a matrix or dataframe. The /csv output type should only be used for matrices and dataframes.")
	}

	#write output
	write.table(output, mytempfile, quote = `!quote`, sep=`!sep`, eol=`!eol`, na=`!na`, dec=`!dec`, row.names=`!row.names`, col.names=`!col.names`);
	return(mytempfile);	
}
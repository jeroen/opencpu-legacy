getprof <- function(fnargs){
	CONTENTTYPE <- "text/plain";
	mytempfile <- do.call(dogetprof, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE));	
}

dogetprof <- function(`#dofn`, ...){
	
	#required
	library(proftools)
	
	#start profiling
	Rprof(proftmp <- tempfile(), interval=0.01)
	
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
	void <- capture.output(print(output));
	
	#write output
	dev.off();
	
	#turn of profiling
	Rprof(memory.profiling=FALSE)
	profdata <- as.data.frame(flatProfile(readProfileData(proftmp)));
	profdata <- cbind(functionname=format(row.names(profdata), width=14), profdata);
	mytempfile <- tempfile()
	write.table(profdata, mytempfile, sep="\t", row.names=F);
	
	#return table
	return(mytempfile)		
}
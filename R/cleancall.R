# TODO: Add comment
# 
# Author: jeroen
###############################################################################


cleancall <- function(`#dofn`, fnargs){
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
	output <- eval(call, fnargs);
	void <- capture.output(print(output));
	
	#return
	return(output);
}

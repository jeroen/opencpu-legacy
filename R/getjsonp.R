# TODO: Add comment
# 
# Author: jeroen
###############################################################################

getjsonp <- function(fnargs){
	CONTENTTYPE <- "application/javascript; charset=UTF8";
	mytempfile <- do.call(dogetjsonp, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

dogetjsonp <- function(`!prefix` = "opencpu_jsonp_handler", ...){
	
	#redirect entire thing to json handler
	oldfile <- dogetjson(...);
	
	#add the padding
	newfile <- tempfile();
	cat(paste(`!prefix`, "(", sep=""), readLines(oldfile), ")", file=newfile, sep="\n");
	return(newfile);	
}
	
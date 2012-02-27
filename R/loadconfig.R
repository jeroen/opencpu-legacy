# TODO: Add comment
# 
# Author: jeroen
###############################################################################


loadconfig <- function(conffile){
	defaultfile <- system.file("config/default.conf", package="opencpu.server")
	defaultconfig <- as.list(fromJSON(defaultfile, simplifyWithNames=FALSE));
	
	if(file.exists(conffile)){
		stopifnot(isValidJSON(conffile));
		myconf <- as.list(fromJSON(conffile, simplifyWithNames=FALSE));
	} else {
		warning("File ", conffile, " not found. Using defaults.")
		myconf <- list();
	}
	
	return(function(key){
		val <- myconf[[key]];
		if(is.null(val)){
			val <- defaultconfig[[key]];
			if(is.null(val)){
				stop("Invalid OpenCPU config '", key, "' ??");
			}
		}
		return(val);
	});	
	
}

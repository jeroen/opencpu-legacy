# TODO: Add comment
# 
# Author: jeroen
###############################################################################

Rd2list <- function(Rd){
	names(Rd) <- substring(sapply(Rd, attr, "Rd_tag"),2);
	temp_args <- Rd$arguments;
	
	Rd$arguments <- NULL;
	myrd <- lapply(Rd, unlist);
	myrd <- lapply(myrd, paste, collapse="");
	
	temp_args <- temp_args[sapply(temp_args , attr, "Rd_tag") == "\\item"];
	temp_args <- lapply(temp_args, lapply, paste, collapse="");
	temp_args <- lapply(temp_args, "names<-", c("name", "description"));
	myrd$arguments <- temp_args;
	return(myrd);
}



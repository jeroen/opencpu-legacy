# TODO: Add comment
# 
# Author: jeroen
###############################################################################


storeplot <- function(displaylist){
	if(is.null(displaylist) || identical(displaylist, list(NULL))){
		return("");
	}
	#displaylist[2] <- NULL;
	return(storeobject(displaylist));	
}

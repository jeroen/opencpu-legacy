# TODO: Add comment
# 
# Author: jeroen
###############################################################################


testmulticore <- function(){
	
	myjob <- parallel(rnorm(100));
	myresult <- collect(myjob, wait=FALSE, timeout=20)[[1]];
	
	if(is.null(myresult)){
		stop("Result is NULL. Bad fork.");		
	}	
	
	kill(myjob, SIGKILL);
	
	print("success.");
	return(DONE);
}
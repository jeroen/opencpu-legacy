#' Used by the OpenCPU framework. Should not be called manually.
#' @return 200 or 400
#' @importFrom interactivity setInteractive 
#' @importFrom multicore collect parallel kill
#' @importFrom opencpu.encode fromJSON asJSON opencpu.encode opencpu.decode
#' @importFrom RJSONIO isValidJSON
#' @import datamap
#' @import tools
#' @export
roothandler <- function(){
	#set some global options
	#moved to .first.Lib()
	
	#wait max 60s for locking of IP address
	#setIpLock(TRUE, timeout=60);

	#fix for tempdir() bug in R:
	myseed <- floor(runif(1,1e8, 1e9));
	set.seed(myseed);
	
	#switch to a temporary working dir
	workdir <- paste("/tmp/workdir", myseed, sep="");
	dir.create(workdir)
	setwd(workdir);
	
	# set resource limits. Seems that this is deprecated by R.
	# suppressWarnings(mem.limits(vsize=config("mem.limit")));	

	#note that this is a backup. The actual job limit is set collect of the fork.
	#this limit must always be higher than the timeout on the fork!
	setTimeLimit(elapsed=config("time.limit"));	
	
	#start timer
	begintime <- Sys.time();
	
	#select method to parse request in a trycatch 
	returndata <- tryCatch({
		request.fork();
	}, error = errorhandler);
		
	#reset timer
	setTimeLimit();
	
	#start timer
	endtime <- Sys.time();
	
	#log the call
	logcall(begintime, endtime, returndata$status)

	#unlock IP address
	#setIpLock(FALSE);		

	#return status code
	return(returndata$status);
}


preprocess <- function(API){
	
	#fix for tempdir() bug in R:
	myseed <- floor(runif(1,1e8, 1e9));
	set.seed(myseed);
	
	#switch to a temporary working dir
	workdir <- paste("/tmp/workdir", myseed, sep="");
	dir.create(workdir)
	setwd(workdir);
	
	#note that this is a backup. The actual job limit is set collect of the fork.
	#this limit must always be higher than the timeout on the fork!
	setTimeLimit(elapsed=config("time.limit"));	
	
	#start timer
	begintime <- Sys.time();
	
	#select method to parse request in a trycatch 
	responsestatus <- tryCatch({
		request.fork(API);
	}, error = errorhandler);
	
	#reset timer
	setTimeLimit();
	
	#start timer
	endtime <- Sys.time();
	
	#log the call
	logcall(begintime, endtime, responsestatus)
	
	#cleanup
	#Note: what happens if the user managed to create a symlink?
	unlink(workdir, recursive=TRUE);
	
	#return status code
	return(responsestatus);
}
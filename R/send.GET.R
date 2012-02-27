# TODO: Add comment
# 
# Author: jeroen
###############################################################################

send.GET <- function(returndata){
	#process output. First the content-type header
	if(!is.null(returndata$type)){
		setContentType(returndata$type);
	}
	
	#if the return type is a binary file, one can optionally suggest a filename.
	if(!is.null(returndata$disposition)){
		setHeader('Content-disposition', paste('attachment;filename=', returndata$disposition, sep=""));
	}	
	
	#caching header
	if(!is.null(returndata$cache)){
		setHeader('Cache-Control', paste("max-age=", returndata$cache, ", public", sep=""));
	}
	
	#binary data
	if(!is.null(returndata$filename)){
		
		#this should be done automatically by sendBin, but it seems to fail for big files
		#setHeader('Content-Length', as.character(file.info(returndata$filename)$size));		
		#seem to result in problems for the subsequent request
		
		#send raw data
		sendBin(readBin(returndata$filename, 'raw', n=file.info(returndata$filename)$size));
		unlink(returndata$filename);
		
	}
}

send.response <- function(returndata){
	#Some sys info:
	setHeader("R-version", substring(sessionInfo()[[1]]$version.string,11,30));
	setHeader("Locale", Sys.getlocale("LC_CTYPE"));
	setHeader("OpenCPU", sessionInfo()$otherPkgs$opencpu.server$Version);
	
	#process output. First the content-type header
	if(!is.null(returndata$type)){
		setContentType(returndata$type);
	}
	
	#if the return type is a binary file, one can optionally suggest a filename.
	if(!is.null(returndata$disposition)){
		setHeader('Content-disposition', paste('attachment;filename=', returndata$disposition, sep=""));
	}	
	
	#Caching headers
	if(!is.null(returndata$cache) && returndata$cache == FALSE){
		setHeader('Cache-Control', "no-store, no-cache, must-revalidate, max-age=0");
	} else if(is.numeric(returndata$cache)){
		setHeader('Cache-Control', paste("max-age=", returndata$cache, ", public", sep=""));
	}
	
	#Enable Cross Origin Resource Sharing
	if(isTRUE(config("enable.cors"))){
		setHeader('Access-Control-Allow-Origin',  '*');
		setHeader('Access-Control-Allow-Methods', 'POST, GET, OPTIONS, PUT, DELETE');
	}
	
	#Cookies! Yum!
	if(is.list(mycookies <- returndata$cookies)){
		for(i in 1:length(mycookies)){
			setCookie(
				name  = mycookies[[i]]$name, 
				value = mycookies[[i]]$value,
				path  = mycookies[[i]]$path
			);
		}
	}
	
	#Add custom headers
	if(!is.null(headerlist <- returndata$headers)){
		for(i in length(headerlist)){
			setHeader(names(headerlist[i]), headerlist[[i]]);
		}
	}
	
	#binary data
	if(!is.null(returndata$filename)){
		
		#this should be done automatically by sendBin, but it seems to fail for big files
		#setHeader('Content-Length', as.character(file.info(returndata$filename)$size));		
		#seem to result in problems for the subsequent request
		
		#send raw data
		sendBin(readBin(returndata$filename, 'raw', n=file.info(returndata$filename)$size));
		#Don't unlink filename here! Some filename are not tempfiles!
		
	}
	
	return(invisible());
}

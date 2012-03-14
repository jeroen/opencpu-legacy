#' Used by the OpenCPU framework. Should not be called manually.
#' @return 200 or 400
#' @importFrom interactivity setInteractive 
#' @importFrom parallel mccollect mcparallel
#' @importFrom opencpu.encode fromJSON asJSON opencpu.encode opencpu.decode as.scalar
#' @importFrom RJSONIO isValidJSON
#' @import RCurl
#' @import datamap
#' @import tools
#' @export
pubhandler <- function(){
	#This is the public api
	#The handler is attached to e.g. /R
	return(preprocess("pubapi"));
}

#' @export
homehandler <- function(){
	#This is the private api
	#The handler is attached to e.g. /home
	return(preprocess("homeapi"));	
}

#' @export
authhandler <- function(){
	#This is the authentication api
	#The handler is attached to e.g. /auth
	return(preprocess("authapi"));	
}


#backward compatibility:
#' @export
roothandler <- pubhandler;
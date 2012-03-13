auth.github <- function(fnargs){
	code <- fnargs$code;
	
	if(!is.null(fnargs$error)){
		stop("Github says: ", fnargs$error);
	}
	
	if(is.null(code)){
		stop("No parameter 'code' found.");
	}
	
	output <- RCurl::postForm(
		uri="https://github.com/login/oauth/access_token", 
		.params=list(
			code = code,
			client_id='5fee823ec85095c103d5', 
			client_secret='9d82a2e68aff1ffa8d50fda62a9bcd69caa9de51'
		)
	);
	
	#parse output
	rawtoken <- rawToChar(output);
	tokenparts <- strsplit(rawtoken, "&")[[1]];
	tokenlist <- strsplit(tokenparts, "=");
	resultlist <- structure(lapply(tokenlist, "[[", 2), names=sapply(tokenlist, "[[", 1));

	#Test if the token actually works
	userdata <- fromJSON(RCurl::getForm("https://api.github.com/user", .params=resultlist));
	
	#return object
	returndata <- object2jsonfile(userdata);
	
	#Set headers
	returndata$cache <- FALSE;
	returndata$cookies <- resultlist[1];
	
	#return
	return(returndata);
}
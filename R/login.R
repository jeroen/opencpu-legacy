login <- function(fnargs){
	
	#this should go in some private key file.
	SECRET <- "9d82a2e68aff1ffa8d50fda62a9bcd69caa9de51";
	
	#We need a 'code' parameter from github.
	code <- fnargs$code;
	
	#Some input validation
	if(!is.null(fnargs$error)){
		stop("Github says: ", fnargs$error);
	}
	
	if(is.null(code)){
		return(sendtoauthpage());
	}
	
	#Exchange the temporary code for an access token
	output <- postForm(
			uri="https://github.com/login/oauth/access_token", 
			.params=list(
					code = code,
					client_id='5fee823ec85095c103d5', 
					client_secret=SECRET 
			)
	);
	
	#parse output
	rawtoken <- rawToChar(output);
	tokenparts <- strsplit(rawtoken, "&")[[1]];
	cookielist <- strsplit(tokenparts, "=");
	cookielist <- lapply(cookielist, as.list);
	
	#Add the names of the cookies
	cookienames <- sapply(cookielist, "[[", 1);
	names(cookielist) <- cookienames;
	
	#Add names to the list elements
	cookielist <- lapply(cookielist, structure, names=c("name", "value"));
	cookielist <- lapply(cookielist, c, list(path="/home"));
	
	#Test if the token actually works
	access_token <- cookielist$access_token$value;
	userdata <- getUserInfo(access_token)
	
	#return object
	returndata <- object2jsonfile(userdata);
	
	#Set headers
	returndata$cache <- FALSE;
	
	#Fix for rapache bug that allows only 1 cookie
	#returndata$cookies <- cookielist;
	returndata$cookies <- cookielist["access_token"];
	
	#return
	return(returndata);
}
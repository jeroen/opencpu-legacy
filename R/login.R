login <- function(fnargs){
	
	#this should go in some private key file.
	if(!file.exists(config("github.secretfile"))){
		stop("Github secret file not found.")
	}
	
	secretdata <- fromJSON(config("github.secretfile"), simplifyWithNames=FALSE);
	SECRET <- secretdata$secret;
	
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
			client_id = config("github.clientid"), 
			client_secret = SECRET 
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
	cookielist <- lapply(cookielist, c, list(path="/home", expires=Sys.time() + 14*24*60*60));
	
	#Test if the token actually works
	access_token <- cookielist$access_token$value;
	userdata <- getUserInfo(access_token)
	
	#create dir.
	#make sure it is public readable though.
	Rusername <- userdata$login;
	homedir <- paste(config("storedir"), "user", sep="/");
	userdir <- paste(homedir, Rusername, sep="/");	
	if(!file.exists(userdir)){
		dir.create(userdir);
	}
	
	#return object
	returndata <- object2jsonfile(list(message="Welcome!", username=Rusername, access_token=access_token));
	
	#Set headers
	returndata$cache <- FALSE;
	
	#add username to the cookie
	cookielist <- c(cookielist, list(list(name="username", value=Rusername, path="/home", expires=Sys.time() + 14*24*60*60)));
	
	#Fix for rapache bug that allows only 1 cookie. (FIXED)
	#returndata$cookies <- cookielist["access_token"];
	returndata$cookies <- cookielist;

	
	#return
	return(returndata);
}
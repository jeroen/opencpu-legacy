sendtoauthpage <- function(){
	
	cookies <- list(access_token = list(name="access_token", path="/home"));
	headers <- list(Location = paste('https://github.com/login/oauth/authorize?client_id=', config("github.clientid"), sep=""))

	#We need to return a non-200 response...
	httperror("You are being redirected...", 302, cookies, headers);
}
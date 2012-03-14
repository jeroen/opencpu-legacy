sendtoauthpage <- function(){
	
	#This HTML page might not work for non-browser clients.
	#We only do this because it is hard to do a real HTTP 302 in rApache.
	
	htmlbody <- paste('
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
		<html>
		  <head>
		    <title>Redirect to auth</title>
		    <meta http-equiv="REFRESH" content="0;url=https://github.com/login/oauth/authorize?client_id=',config("github.clientid"),'">
		  </head>
		  <body>
		    Not logged in. Redirecting to authentication page.
		  </body>
		</html>
	', sep="");

	mytempfile <- tempfile();
	writeLines(htmlbody, mytempfile);
	contenttype <- "text/html"
	cookies <- list(access_token = list(name="access_token", path="/home"));
	return(list(filename = mytempfile, type = contenttype, cookies=cookies));
}
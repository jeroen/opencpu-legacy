sendtoauthpage <- function(){
	
	htmlbody <- '
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
		<html>
		  <head>
		    <title>Redirect to auth</title>
		    <meta http-equiv="REFRESH" content="0;url=https://github.com/login/oauth/authorize?client_id=5fee823ec85095c103d5">
		  </head>
		  <body>
		    Not logged in. Redirecting to authentication page.
		  </body>
		</html>
	';

mytempfile <- tempfile();
	writeLines(htmlbody, mytempfile);
	contenttype <- "text/html"
	cookies <- list(access_token = list(name="access_token", path="/home"))
	return(list(filename = mytempfile, type = contenttype, cookies=cookies));
}
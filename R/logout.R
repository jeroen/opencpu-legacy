logout <- function(){
	
	#some useless content
	returndata <- object2jsonfile("Logout successful.");
	
	#Deletes the cookie
	returndata$cookies <- list(list(name="access_token", path="/home"));
	
	#return
	return(returndata);
}
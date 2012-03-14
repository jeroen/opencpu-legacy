logout <- function(){
	
	#some useless content
	returndata <- object2jsonfile(list(message="Logout successful. Drive safely!"));
	
	#Deletes the cookie
	returndata$cookies <- list(list(name="access_token", path="/home"));
	
	#return
	return(returndata);
}
httperror <- function(message, statuscode=400, cookies = NULL, headers = NULL){
	myError <- simpleError(message);
	myError$statuscode  <- statuscode;
	myError$cookies <- cookies;
	myError$headers <- headers;
	stop(myError);
}

#tryCatch(httperror("foo", 302), error=function(e){print(e$statuscode)})
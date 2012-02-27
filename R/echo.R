#' Echo handler used for debugging of RApache
#' @return some info
#' @export
echo <- function(){
	cat("This is the rapache test handler!\n\n");
	
	cat("Interactive: ", interactive(),"\n\n")

	print(sessionInfo());
	
	cat("\nGET:\n")
	print(GET);	
	
	cat("\nPOST:\n");
	print(POST);
	
	cat("\nFILES:\n");
	print(FILES);
	
	cat("\nCOOKIES:\n");
	print(COOKIES);	
	
	cat("\nSERVER:\n");
	print(SERVER);
	
	cat("\nSearch path:\n")
	print(search());
	
	cat("\nloadedNamespaces():\n")
	print(loadedNamespaces());
	
	print(environment(FILES))
	
	
}
# This handler tries to write the error to a file that can later be written. 
# Note that for this to work, we have to add an ErrorDocument directive in the apache config file, 
# that corresponds to the Location where our service is mounted. Like this:

# <Location /R>
#	 SetHandler r-handler
#    RHandler opencpu.server::roothandler
# </Location>
# ErrorDocument 400 /R/lasterror

errorhandler <- function(e){
	#check if file exists
	if(!file.exists("/tmp/lasterror")){
		file.create("/tmp/lasterror");
	}
	
	#try to open connection for writing
	errorfile <- try(file("/tmp/lasterror", open="w"), silent=T);
	
	#return another error
	if(class(errorfile)=="try-error"){
		cat(e$message,"\n\n");
		cat("IMPORTANT: on top of that we could not write the error to file: /tmp/lasterror. Therefore you are now seeing a 200 OK instead of a 400 HTTP_BAD_REQUEST. \nPlease ask sysadmin to remove or chmod this file.\n\n");	
		return(OK);
	}
	
	#strip some of the error metamessage
	errormessage <- e$message;
	errormessage <- gsub("Error in.* : ","Error: ", errormessage);
	errormessage <- gsub("Error : Error","Error", errormessage);
	errormessage <- gsub("Error: \n ","Error:", errormessage);
	
	#write errormessage to a file
	write(errormessage, file=errorfile);
	
	#log errors
	if(!is.null(config("errorlog")) && config("errorlog") != ""){
		cleanerror <- gsub("\n", ".", errormessage);
		cleanerror <- gsub("\"", "'", cleanerror);
		cleanerror <- paste("\"", cleanerror, "\"", sep="");
		errorline <- paste(Sys.time(), SERVER$remote_ip, gsub("\n", " ", cleanerror), SERVER$method, SERVER$unparsed_uri, sep="\t");
		try(write(errorline, file=config("errorlog"), append=TRUE));
	}	
	
	#optionally also include the last warning (doesn't work for warnings in child)
	if(config("return.warnings") && length(warnings()) > 0){
	  warningmessage <- "\n\nAdditionaly some warnings:\n";
	  warningmessage <- paste(warningmessage, tail(warnings(),1)[[1]], ":\n", sep="");
	  warningmessage <- paste(warningmessage, names(tail(warnings(),1)[1]));
	  write(warningmessage, errorfile, append=T);
	}
	
	close(errorfile)
	return(list(status=HTTP_BAD_REQUEST));
}
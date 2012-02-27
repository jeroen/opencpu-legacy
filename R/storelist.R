# TODO: Add comment
# 
# Author: jeroen
###############################################################################


storelist <- function(Storelocation, ObjectID){
	
	#check if the template is available:
	stopifnot(file.exists(system.file("templates/storelist.html", package="opencpu.server")));
	
	#read config
	STOREDIR <- config("storedir");		
	
	#find the file
	objectfile <- switch(Storelocation,
		"tmp" = paste(STOREDIR, "/tmp/", ObjectID, sep=""),
		stop("invalid store: ", Storelocation)
	);
	
	#check if it exists
	if(!file.exists(objectfile)){
		stop("requested object not found in store: ", paste("/",Storelocation,"/", ObjectID, sep=""));
	}
	
	mytempfile <- tempfile();
	template <- readLines(system.file("templates/storelist.html", package="opencpu.server"));

	template <- gsub("TEMPLATEKEY", paste(Storelocation, ObjectID, sep="/"), template);
	
	writeLines(template, mytempfile);
	return(mytempfile);	
}

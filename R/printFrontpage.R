# TODO: Add comment
# 
# Author: jeroen
###############################################################################


printFrontpage <- function(){
	#check if the template is available:
	stopifnot(file.exists(system.file("templates/frontpage.html", package="opencpu.server")));
	
	#return template
	return(list(
		filename=system.file("templates/frontpage.html", package="opencpu.server"), 
		type="text/html", 
		status=OK
	));
}

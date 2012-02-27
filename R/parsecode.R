# TODO: Add comment
# 
# Author: jeroen
###############################################################################


parsecode <- function(text){
	text <- gsub("\r\n", "\n", text);
	text <- gsub("\r", "\n", text);
	return(parse(text=text));
}

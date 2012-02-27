# TODO: Add comment
# 
# Author: jeroen
###############################################################################


reproduce <- function(x){
	#x is a list of arguments for 'eval'.
	stopifnot(class(x) == "reproducible");
	return(do.call("eval", x));
}

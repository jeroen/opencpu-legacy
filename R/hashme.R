# TODO: Add comment
# 
# Author: jeroen
###############################################################################

#should replace this with sha1

hashme <- function(filename){
	return(unname(md5sum(filename)));
}

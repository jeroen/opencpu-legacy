#should replace this with digest package

hashme <- function(filename){
	return(unname(md5sum(filename)));
}

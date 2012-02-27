# TODO: Add comment
# 
# Author: jeroen
###############################################################################


checkfordir <- function(path){
	return(isTRUE(file.info(path)$isdir));
}

setLibPaths <- function(newlibs){
	newlibs <- newlibs[sapply(newlibs, checkfordir)]
	assign(".lib.loc", newlibs, envir=environment(.libPaths));
}


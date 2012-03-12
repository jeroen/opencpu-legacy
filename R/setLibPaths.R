checkfordir <- function(path){
	return(isTRUE(file.info(path)$isdir));
}

#because .libPaths() only appends paths, doesn't replace anything.
setLibPaths <- function(newlibs){
	newlibs <- newlibs[sapply(newlibs, checkfordir)]
	assign(".lib.loc", newlibs, envir=environment(.libPaths));
}


fixobject <- function(myObject){
	if("recordedplot" %in% class(myObject)){
		library(grid);
		for(i in 1:length(myObject[[1]])) {
			if( "NativeSymbolInfo" %in% class(myObject[[1]][[i]][[2]][[1]]) ){
				myObject[[1]][[i]][[2]][[1]] <- getNativeSymbolInfo(myObject[[1]][[i]][[2]][[1]]$name);
			}
		}
	}
	return(myObject);
}
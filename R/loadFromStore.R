loadFromStore <- function(ObjectID, Storelocation="tmp"){
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
	
	#read the object and return it.
	myObject <- readRDS(objectfile);
	
	#restore memory pointers for lattice plots
	if("recordedplot" %in% class(myObject)){
	  library(grid);
	    for(i in 1:length(myObject[[1]])) {
	      if( "NativeSymbolInfo" %in% class(myObject[[1]][[i]][[2]][[1]]) ){
	        myObject[[1]][[i]][[2]][[1]] <- getNativeSymbolInfo(myObject[[1]][[i]][[2]][[1]]$name);
	    }
	  }
	}
	
	#return
	return(myObject);
}

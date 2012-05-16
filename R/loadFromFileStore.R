loadFromFileStore <- function(ObjectID, Storelocation="tmp"){
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
	myObject <- fixobject(myObject)
	
	#return
	return(myObject);
}

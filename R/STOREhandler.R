# TODO: Add comment
# 
# Author: jeroen
###############################################################################


STOREhandler <- function(Storelocation, ObjectID, Rformat){
	
	if(is.na(Rformat) || Rformat == ""){
		if(any(is.na(c(Storelocation, ObjectID))) || any(c(Storelocation, ObjectID) == "")){
			stop("Invalid URI: ", SERVER$path_info)
		} else {
			#print the html page with info about the store
			returndata <- list(
				type = "text/html",
				format = "html",
				filename = storelist(Storelocation, ObjectID),
				cache = config("cache.store"),
				status = 200		
			);
			return(returndata);			
		}			
	}
	


	#Parse HTTP request
	#uri <- SERVER$path_info;
	
	#Load package and function
	#packageAndFunction <- strsplit(substring(uri,2),"/")[[1]];
	#if(length(packageAndFunction) != 3 || any(packageAndFunction=="")){
	#	stop("invalid url: ", uri);
	#}
	
	#e.g /store/png/tmp/7648ab9e6f81c06867ce3492bc9067e9

	#Rformat <- packageAndFunction[1];
	#Storelocation <- packageAndFunction[2];
	#ObjectID <- packageAndFunction[3];
	
	#parse arguments
	if(length(fnargs) == 0){
		fnargs <- list();
	} else {
		#parse HTTP arguments and evaluate
		fnargs <- lapply(fnargs, tryParse);
		exprargs <- sapply(fnargs, is.expression);
		fnargs[exprargs] <- lapply(fnargs[exprargs], eval);	
		
		#check for illegal code injection
		if(any(substr(names(fnargs),1,1) == "#")){
			stop("arguments are not allowed to start with a #");
		}
		
		#check for a seed
		if(!is.null(fnargs[["!seed"]])){
			set.seed(fnargs[["!seed"]]);
			fnargs[["!seed"]] <- NULL;
		}
	}

	#add the function as an argument		
	fnargs[["#dofn"]] <- identity;
	
	#load the object from the store
	fnargs[["x"]] <- loadFromStore(Storelocation, ObjectID);
	
	#perform the actual request
	returndata <- switch(Rformat,
		pdf = plotpdf(fnargs),
		png = plotpng(fnargs),
		svg = plotsvg(fnargs),
		json = getjson(fnargs),
		jsonp = getjsonp(fnargs),
		encode = getencode(fnargs),
		rds = getrds(fnargs),
		rda = getrda(fnargs),
		ascii = getascii(fnargs),
		csv = getcsv(fnargs),
		table = gettable(fnargs),
		bin = getbin(fnargs),
		stop("Invalid store output ", Rformat, " for http method ", SERVER$method)
	);	
	
	returndata$format <- Rformat;
	returndata$cache <- config("cache.store");
	returndata$status <- 200;
	
	#return the list with content and type and status
	return(returndata);
}

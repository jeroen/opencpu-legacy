FUNCTIONhandler <- function(Rpackage, Rfunction, Rformat){
	
	if( any(is.na(c(Rpackage, Rfunction, Rformat))) || any(c(Rpackage, Rfunction, Rformat) == "") ){
		stop("Invalid URI: ", SERVER$path_info)
	}
	
	#Check whitelist
	if(any(config("whitelist") != FALSE)){
		if(!Rpackage %in% config("whitelist")){
			stop("Package: ", Rpackage, " is not in the config whitelist.")
		}
	}

	#expliclty specified location of the function
	if(length(grep(":", Rpackage)) > 0){
		prefix <- strsplit(Rpackage, ":")[[1]][1];	
		functionLocation <- strsplit(Rpackage, ":")[[1]][2]; 
		RPC.FN <- switch(prefix,
			package = loadFromPackage(functionLocation, Rfunction),
			store = loadFromStore(Rfunction, functionLocation),
			stop("Unknown prefix: ", prefix)
		);
	} else {
		#location not specified, default assumes a package
		RPC.FN <- loadFromPackage(Rpackage, Rfunction);
	}
	
	if(!is.function(RPC.FN)){
		stop("The object that was specified is not a function.")	
	}
	
	#Load the required library
	#require(Rpackage, quietly=T, character=T);	
	
	if(length(fnargs) == 0){
		fnargs <- list();
	} else {
		#delete filenames from the ARGS variable
		fnargs[names(NEWFILESVAR)] <- NULL;

		emptyargs <- sapply(fnargs, is.null);
		#Check for empty arguments
		if(any(emptyargs)){
			stop("Empty arguments: ", paste(names(fnargs)[which(sapply(fnargs, is.null))], collapse=", "))
		}
		
		#parse HTTP arguments
		fnargs <- lapply(fnargs, tryParse);

		#parse files
		fnargs <- parseFiles(fnargs);	
		
		#evaluate expressions from tryparse
		# TO DO: this is actually too early. 
		# Better to evaluate all the way at the actual call.

		# evaluate metaparameters
		metaparams <- sapply(fnargs, is.expression) & grepl("^!", names(fnargs));
		if(sum(metaparams) > 0){
			fnargs[metaparams] <- lapply(fnargs[metaparams], eval);
		}
		
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
	fnargs[["#dofn"]] <- RPC.FN;		
			
	#perform the actual request
	returndata <- switch(SERVER$method,
		GET = switch(Rformat,
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
			file = getfile(fnargs),
			plot = getplot(fnargs),
			save = getsave(fnargs),
			bin = getbin(fnargs),
			prof = getprof(fnargs),
			stop("Invalid output ", Rformat, " for http method ", SERVER$method)
		),
		POST = switch(Rformat,
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
			file = getfile(fnargs),
			plot = getplot(fnargs),
			save = getsave(fnargs),
			bin = getbin(fnargs),
			prof = getprof(fnargs),
			stop("Invalid output ", Rformat, " for http method ", SERVER$method)
		), 
		stop("Invalid method: ", SERVER$method)
	);	
	returndata$format <- Rformat;
	returndata$cache <- config("cache.call");
	returndata$status <- 200;
	
	#return the list with content and type and status
	return(returndata);
}

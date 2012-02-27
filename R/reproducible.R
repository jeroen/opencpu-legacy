## This stuff is copied from the reproducible package.

reproducible <- function(expr, envir=list(), seed, output=FALSE){
	
	if(missing(expr)){
		stop('argument "expr" is required.');
	}
	
	expr <- as.list(match.call())$expr;
	
	TIME <- Sys.time();
	if(missing(seed)){
		seed <- round(runif(1,1,1e8));
	} 	
	
	if(is.environment(envir)){
		envir <- as.list(envir);
	}
	
	enclosing <- as.environment(grep("package:", search(), value=T)[1]);
	#enclosing <- as.environment("OpenCPU");
	
	
	#give it a try run
	set.seed(seed);
	returnobj <- eval(expr, envir, enclos=enclosing);
	
	#We want the session info after the evaluation. Just in case it loads libaries or something.
	SESSION <- sessionInfo();	
	
	#the closure that we will return.
	reproduce <- function(){
		
		#reload dependencies
		for(depends in SESSION$otherPkgs){
			Package <- depends$Package;
			Version <- depends$Version;
			cat("Attaching package:", Package, "\n");
			library(Package, character.only=TRUE);
			if(Version != sessionInfo()$otherPkgs[[Package]]$Version){
				warning("Other version for package", Package, ". Reproducible was generated with ", Package, "_", Version);
			}
		}
		
		#Do the same for imported packages
		for(imports in SESSION$loadedOnly){
			Package <- imports$Package;
			Version <- imports$Version;
			cat("Importing package:", Package, "\n");
			getNamespace(Package);
			if(Version != sessionInfo()$loadedOnly[[Package]]$Version){
				warning("Other version for package", Package, ". Reproducible was generated with ", Package, "_", Version);
			}
		}		
		
		set.seed(seed);
		output <- eval(expr, envir, enclos=enclosing);
		return(output);
	}
	
	class(reproduce) <- "reproducible";
	
	if(isTRUE(output)){
		return(list(reproducible=reproduce, output=returnobj))	
	} else {	
		return(reproduce);
	}
}




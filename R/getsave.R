# TODO: Add comment
# 
# Author: jeroen
###############################################################################


getsave <- function(fnargs){
	CONTENTTYPE <- "text/plain; charset=UTF8";
	mytempfile <- do.call(dogetsave, fnargs);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

dogetsave <- function(`#dofn`, `!saveobject`=TRUE, `!savegraphs`=TRUE, `!savefiles`=TRUE, `!reproducible`=FALSE, `!printoutput`= FALSE, ...){
	
	#prepare plot saving:
	plotdumpdir <- file.path("/tmp", paste("plotdump", floor(runif(1,1e8, 1e9)), sep=""));
	dir.create(plotdumpdir);
	pdf(file.path(plotdumpdir,"plotcount%03d.ps"), onefile=FALSE);
	dev.control(displaylist="enable");
	emptyplot <- recordPlot();
	plotenv = new.env();
	assign("myplots", list(), plotenv);
	assign("hasplots", FALSE, plotenv);
	
	plotcapture <- function(...) {
		if(get("hasplots", plotenv) == FALSE){
			assign("hasplots", TRUE, plotenv);
		} else {
			pagecounter <- max(as.numeric(substring(grep("plotcount",list.files(plotdumpdir), value=T),10,12)));
			allplots <- get("myplots", plotenv);
			allplots[[pagecounter]] <- recordPlot();
			assign("myplots", allplots, plotenv);
			#assign("myplots", append(get("myplots", plotenv), list(recordPlot())), plotenv);
		}
	}

	setHook("before.plot.new", NULL, "replace");
	setHook("before.grid.newpage", NULL, "replace");	
	
	setHook("before.plot.new", plotcapture);	
	setHook("before.grid.newpage", plotcapture);

	#build the function call and evaluate expressions at the very last moment.
	fnargs <- as.list(match.call(expand.dots=F)$...);
	argn <- lapply(names(fnargs), as.name);
	names(argn) <- names(fnargs);
	
	#insert expressions into call
	exprargs <- sapply(fnargs, is.expression);
	if(length(exprargs) > 0){
		expressioncalls <- lapply(fnargs[exprargs], "[[", 1);
		argn[names(fnargs[exprargs])] <- expressioncalls;
	}
	
	#call the new function
	mycall <- as.call(c(list(as.name("#dofn")), argn));
	fnargs <- c(fnargs, list("#dofn" = `#dofn`));
	
	detach("package:opencpu.server");

	if(isTRUE(`!reproducible`)){
		reprolist <- eval(call('reproducible', expr=mycall, envir=fnargs, output=TRUE));
		reproduce.object <- reprolist$reproducible;
		output <- reprolist$output;		
	} else {
		output <- eval(mycall, fnargs, globalenv());	
	}

	if(`!printoutput`){
		#Feb 10, 2012: This one is causing major issues!
		void <- capture.output(print(output));
	}
	
	#we need some functions so reload the library
	#if(length(config("syslib")) > 0){
	#	#it might or might not be in the system library.
	#	.libPaths(config("syslib"));
	#	library("opencpu.server");
	#	.libPaths("");
	#}
	
	#save final plot and close device
	if(get("hasplots", plotenv) || !identical(emptyplot, recordPlot())){
		pagecounter <- max(as.numeric(substring(grep("plotcount",list.files(plotdumpdir), value=T),10,12)));
		allplots <- get("myplots", plotenv);
		allplots[[pagecounter]] <- recordPlot();
		assign("myplots", allplots, plotenv);
	#assign("myplots", append(get("myplots", plotenv), list(recordPlot())), plotenv);
	}
	dev.off();
	setHook("before.plot.new", NULL, "replace");
	setHook("before.grid.newpage", NULL, "replace");

	#write object and plots to files
	returnlist <- list();
	if(`!saveobject`){
		if(!is.null(output)){
			returnlist$object <- as.scalar(storeobject(output));
		} else {
			returnlist$object <- vector();
		}
	} 
	
	if(`!savegraphs`){
		returnlist$graphs <- sapply(get("myplots", plotenv), storeplot);
	} 
	
	if(`!savefiles`){
		returnlist$files <- lapply(as.list(sapply(list.files(), storebinaryfile)), as.scalar)
	} 
	
	if(`!reproducible`){
		returnlist$reproducible <- as.scalar(storeobject(reproduce.object));
	} 	
	
	#write output	
	mytempfile <- tempfile();
	write(asJSON(returnlist, pretty=TRUE), mytempfile);
	return(mytempfile);	
}

HTTPGET.PUB.PACKAGE.OBJECT.HELP <- function(Rpackage, Robject, Rhelpout){
	
	if(is.na(Rhelpout)){
		return(
			object2jsonfile(
				c("html", "text", "latex", "json", "pdf", "rd")
			)
		);
	}
	
	return(
		switch(Rhelpout,
			"html" = getHelpHTML(Robject, package=Rpackage),
			"rd" = getHelpRd(Robject, package=Rpackage),
			"text" = getHelpText(Robject, package=Rpackage),
			"latex" = getHelpLatex(Robject, package=Rpackage),
			"json" = getHelpJSON(Robject, package=Rpackage),
			"pdf" = getHelpPDF(Robject, package=Rpackage),
			stop("Unknown format: /", Rhelpout)
		)
	);
}

cleantext <- function(string, cleaneol=TRUE){
	if(isTRUE(cleaneol)){
		string <- gsub('[\n\t ]+', ' ', string);
	} else {
		string <- gsub('[\t ]+', ' ', string);		
	}
	string <- gsub('^[\n\t ]+', '', string);
	string <- gsub('[\n\t ]+$', '', string);
	return(string);
}

gethelp <- function(myfn, package){
	#we need this becuase the 'help' function does not understand variables as arguments.
	eval(call('help', myfn, package=package))
}

getHelpRd <- function(...){
	CONTENTTYPE <- "application/octet-stream";
	thefile <- gethelp(...);
	mytempfile <- tempfile();
	saveRDS(utils:::.getHelpFile(thefile), mytempfile);
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition="helpobject.rds"));
}

getHelpHTML <- function(...){
	CONTENTTYPE <- "text/html";
	thefile <- gethelp(...)
	myhtml <- paste(capture.output(tools:::Rd2HTML(
							utils:::.getHelpFile(thefile),
							stylesheet="/R/call/base/system.file/file?package='opencpu.server'&file='templates/R.css'"
					)), collapse="\n");
	mytempfile <- tempfile();
	write(myhtml, mytempfile);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

getHelpText <- function(...){
	CONTENTTYPE <- "text/plain";
	thefile <- gethelp(...);
	mytext <- paste(capture.output(tools:::Rd2txt(utils:::.getHelpFile(thefile), options=list(underline_titles=FALSE, code_quote=FALSE))), collapse="\n");
	mytempfile <- tempfile();
	write(mytext, mytempfile);
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

getHelpLatex <- function(...){
	CONTENTTYPE <- "text/plain";
	thefile <- gethelp(...)
	mytext <- paste(capture.output(tools:::Rd2latex(utils:::.getHelpFile(thefile))), collapse="\n");
	mytempfile <- tempfile();
	write(mytext, mytempfile);	
	return(list(filename = mytempfile, type = CONTENTTYPE));
}

getHelpList <- function(...){
	thefile <- gethelp(...)
	myrd <- utils:::.getHelpFile(thefile);
	return(Rd2list(myrd));
}

getHelpPDF <- function(myfn, package){
	CONTENTTYPE <- "application/pdf";	
	thefile <- eval(call('help', myfn, package=package, help_type="pdf"));
	print(thefile);
	mytempfile <- tempfile();
	oldfilename <- paste(myfn, ".pdf", sep="");
	if(!file.exists(oldfilename)){
		stop("File", oldfilename, "was not created :-(");
	}
	file.copy(oldfilename, mytempfile);
	return(list(filename = mytempfile, type = CONTENTTYPE, disposition=oldfilename));
}

getHelpJSON <- function(...){
	CONTENTTYPE <- "text/plain";
	myrd <- getHelpList(...);
	temp_arg <-myrd$arguments
	temp_examples <- myrd$examples;
	myrd$arguments <- NULL;
	myrd$examples <- NULL;
	myrd <- lapply(myrd, cleantext);
	myrd <- lapply(myrd, as.scalar);
	myrd$examples <- as.scalar(cleantext(temp_examples, cleaneol=FALSE));
	myrd$arguments <- lapply(temp_arg, lapply, cleantext);
	myrd$arguments <- lapply(myrd$arguments, lapply, as.scalar);
	
	#return
	return(object2jsonfile(myrd));
}
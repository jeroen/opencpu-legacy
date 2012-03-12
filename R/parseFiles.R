# TODO: Add comment
# 
# Author: jeroen
###############################################################################


parseFiles <- function(fnargs, files){
	if(length(files) > 0){
		argnames <- names(files);
		filenames <- unname(sapply(files, "[[", "name"));
		filepaths <- unname(sapply(files, "[[", "tmp_name"));
		
		#if the parameter name is prefixed with !file, the file kept as is.
		for(i in which(substring(argnames,0,6)=="!file:")){
			thisfile <- filepaths[i];
			attr(thisfile, "filename") <- filenames[i];
			fnargs[[substring(argnames[i],7)]] <- thisfile;
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];				
		}
		
		#if the parameter name is prefixed with !copy, the file is copied to the globalenv
		for(i in which(substring(argnames,0,6)=="!copy:")){
			thisfile <- filepaths[i];
			attr(thisfile, "filename") <- filenames[i];
			assign(substring(argnames[i],7), thisfile, as.environment("OpenCPU"))
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];				
		}		
		
		#we assumed that files are RDS files
		if(length(argnames) > 0){
			for(i in 1:length(argnames)){
				fnargs[[argnames[i]]] <- readRDS(filepaths[i]);
			}			
		}
	}		
	return(fnargs);	
}

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
		file_files <- which(substring(argnames,0,6)=="!file:");
		
		if(length(file_files) > 0){
			for(i in file_files){
				thisfile <- filepaths[i];
				attr(thisfile, "filename") <- filenames[i];
				fnargs[[substring(argnames[i],7)]] <- thisfile;
			}
			argnames <- argnames[-file_files];
			filenames <- filenames[-file_files];
			filepaths <- filepaths[-file_files];	
		}
		
		#if the parameter name is prefixed with !copy, the file is copied to the globalenv
		copy_files <- which(substring(argnames,0,6)=="!copy:");
		if(length(copy_files) > 0){
			for(i in copy_files){
				thisfile <- filepaths[i];
				attr(thisfile, "filename") <- filenames[i];
				assign(substring(argnames[i],7), thisfile, globalenv())
			}
			argnames <- argnames[-copy_files];
			filenames <- filenames[-copy_files];
			filepaths <- filepaths[-copy_files];				
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

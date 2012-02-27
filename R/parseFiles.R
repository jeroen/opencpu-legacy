# TODO: Add comment
# 
# Author: jeroen
###############################################################################


parseFiles <- function(fnargs){
	if(exists("NEWFILESVAR") && (length(NEWFILESVAR) > 0)){
		argnames <- names(NEWFILESVAR);
		filenames <- unname(sapply(NEWFILESVAR, "[[", "name"));
		filepaths <- unname(sapply(NEWFILESVAR, "[[", "tmp_name"));
		
		for(i in which(argnames == "!tabledata")){
			tabledata <- read.table(filepaths[i]);
			attach(tabledata, name=filenames[i]);
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];			
		}			
		
		for(i in which(argnames == "!csvdata")){
			csvdata <- read.csv(filepaths[i]);
			attach(csvdata, name=filenames[i]);
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];					
		}
		
		for(i in which(argnames == "!csv2data")){
			csv2data <- read.csv2(filepaths[i]);
			attach(csv2data, name=filenames[i]);
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];					
		}		
		
		for(i in which(argnames == "!delimdata")){
			delimdata <- read.delim(filepaths[i]);
			attach(delimdata, name=filenames[i]);
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];					
		}	
		
		for(i in which(argnames == "!delim2data")){
			delim2data <- read.delim2(filepaths[i]);
			attach(delim2data, name=filenames[i]);
			argnames <- argnames[-i];
			filenames <- filenames[-i];
			filepaths <- filepaths[-i];					
		}
		
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

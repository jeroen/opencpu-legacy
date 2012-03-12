storeobject <- function(obj){
	#save displaylist to file
	plottempfile <- tempfile();
	saveRDS(obj, plottempfile);

	#store the file
	return(storefile(plottempfile));	
}

storeobject <- function(obj){
	#save displaylist to file
	plottempfile <- tempfile();
	saveRDS(obj, plottempfile);

	#store the file
	output <- storefile(plottempfile);
	
	#clean up
	unlink(plottempfile);
	
	#return
	return(output);	
}

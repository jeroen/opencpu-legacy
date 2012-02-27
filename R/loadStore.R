loadStore <- function(storename){
	newMapper(
		type = "store",
		init = function(map, storename, storepath=paste(syspath, storename, sep="/"), symbols=list.files(storepath)){

			# Install symbols that the users passes in from newMap().
			lapply(symbols,install,map)

			#add some state
			map$storepath = storepath;

			# Returning FALSE means failure
			return(TRUE)
		},
		get = function(x) {
			object <- readRDS(paste(storepath, x, sep="/"));
			return(object);
		},

		assign = function(x,val){
			stop("Don't assign variables to the store datamap.");
		},

		finalize = function(map){
			cat("Finalization can clear any state, like shutting down database\n")
			cat("connections, socket connections, etc.\n")
		},

		syspath = "/mnt/export/store"
		# The rest of the arguments are copied to the internal portion of the map.
	)
	mapAttach(newMap("store", storename=storename), name=paste("store", storename, sep=":"));
}

#loadStore("tmp")
#ls("store:tmp");
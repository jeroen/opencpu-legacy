# TODO: Add comment
# 
# Author: jeroen
###############################################################################


logcall <- function(begintime, endtime, status){
	#access log
	if(!is.null(config("accesslog")) && config("accesslog") != ""){
		totaltime <- formatC(unclass(endtime - begintime), format="f", digits=3, width=6, flag = "0");
		logline <- paste(begintime, SERVER$remote_ip, totaltime, status, SERVER$method, SERVER$uri, sep="\t");
		try(write(logline, config("accesslog"), append=T));
	}
}

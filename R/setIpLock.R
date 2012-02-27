# TODO: Add comment
# 
# Author: jeroen
###############################################################################


setIpLock <- function(lock, timeout=60){

	lockfile <- paste("/tmp/IPLOCK_", SERVER$remote_ip, sep="");	
	
	if(lock){
		#We are locking this IP address		
		for(i in 1:timeout){
			if(!file.exists(lockfile)){
				file.create(lockfile);
				return(TRUE);
			}			
			if(i == timeout){
				stop("Unable to lock IP address");
			}
			Sys.sleep(1);			
		}
	} else {
		#We are unlocking this IP address
		file.remove(lockfile);
		return(TRUE);
	}
}

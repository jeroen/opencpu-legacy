# TODO: Add comment
# 
# Author: jeroen
###############################################################################


updateAliases <- function(){
	system(paste("bash ", system.file("aliases/aliases.sh",package="opencpu.server")));
}

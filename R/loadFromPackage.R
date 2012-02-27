# TODO: Add comment
# 
# Author: jeroen
###############################################################################


loadFromPackage <- function(Rpackage, Rfunction){
	library(Rpackage, character.only=T);
	return(get(Rfunction, paste("package:", Rpackage, sep="")));
}

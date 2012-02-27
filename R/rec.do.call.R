# TODO: Add comment
# 
# Author: jeroen
###############################################################################


rec.do.call <- function(fnnames, fnargs, object=NULL){
	if(length(fnnames) == 1){
		cat(fnnames, "(", paste(names(fnargs), collapse=","), ").\n\n", sep="");		
		return(do.call(fnnames, c(object, fnargs)));  
	}
	
	thisfn <- head(fnnames, 1);
	
	if(is.null(getS3method(thisfn, class(object[[1]]), T))){
		fnformals <- formals(thisfn);
	} else {
		fnformals <- formals(getS3method(thisfn, class(object[[1]])));
	}
	
	matchindex <- na.omit(pmatch(names(fnformals), names(fnargs)));
	cat("Matched: ", thisfn, "(", paste(names(fnargs[matchindex]), collapse=","), "). ", sep="");	
	
	myobj <- do.call(thisfn, c(object, fnargs[matchindex]));
	
	if(length(matchindex)==0){
		remaining.fnargs <- fnargs;		
	} else {
		remaining.fnargs <- fnargs[-matchindex];
	}
	
	cat("Remaining:", "(", paste(names(remaining.fnargs), collapse=","), "). \n", sep=""); 
	
	rec.do.call(tail(fnnames, -1), remaining.fnargs, list(myobj));
}

#two examples:
#rec.do.call(c("glm","anova","print"), list(formula="dist~speed", data=cars, test="Chisq", digits=1, signif.stars=F))
#rec.do.call(c("glm","coef","round"), list(formula="dist~speed", data=cars, digits=1))
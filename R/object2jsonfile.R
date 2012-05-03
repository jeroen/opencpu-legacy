object2jsonfile <- function(object, fnargs=list(), cache=FALSE) {
	return(renderobject(object, "json", fnargs, cache=cache));
}
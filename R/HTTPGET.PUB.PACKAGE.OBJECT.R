HTTPGET.PUB.PACKAGE.OBJECT <- function(Rpackage, Robject, Routput, fnargs){

	object <- getExportedValue(Rpackage, Robject);
	return(renderobject(object, Routput, fnargs));

}
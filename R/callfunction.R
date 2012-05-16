callfunction <- function(fnargs, Routput){
	#perform the actual request
	returndata <- switch(Routput,
		pdf = plotpdf(fnargs),
		png = plotpng(fnargs),
		svg = plotsvg(fnargs),
		json = getjson(fnargs),
		jsonp = getjsonp(fnargs),
		encode = getencode(fnargs),
		rds = getrds(fnargs),
		rda = getrda(fnargs),
		file = getfile(fnargs),
		ascii = getascii(fnargs),
		csv = getcsv(fnargs),
		table = gettable(fnargs),
		bin = getbin(fnargs),
		plot = getplot(fnargs),
		print = getprint(fnargs),
		save = getsave(fnargs),
		stop("Unknown output format: ", Routput)
	);		
}
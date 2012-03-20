.onLoad <- function(path, package){

	conffile <- "/etc/opencpu/server.conf";
	config <- loadconfig(conffile);	
	attach(list(config = config), name="OpenCPU");

	options(repos='http://cran.us.r-project.org');
	options(keep.source = FALSE);
	options(useFancyQuotes = FALSE);
	setInteractive(FALSE);
	Sys.setlocale(category='LC_ALL', 'en_US.UTF-8');
	
	#add non-system opencpu libraries
	if(length(config("libpaths")) > 0){
		setLibPaths(config("libpaths"))
	}
	
	#preload libraries
	for(thispackage in config("preload")){
		#try to preload the packages. Make sure to complain about non existing packages.
		try(getNamespace(thispackage), silent=FALSE);
	}
	
	#little hack to have this available after we detach
	#assign("hashme", opencpu.server:::hashme, envir=as.environment("package:base"))
	
	#for the logs:
	message("OpenCPU server ready...")
}

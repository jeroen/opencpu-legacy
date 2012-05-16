######
# NOTE: This code needs an update. The idea is that arguments that start with { or [ are parsed as JSON objects
#       Other arguments should be either be evaluated or turned into a expression or name object that will automatically
#		be evaluated during the actual call.

tryParse <- function(string, disable.eval = config("disable.eval")){

	if(is.null(string)){
		return(NULL)
	}
	
	string <- as.character(string);
	
	if(nchar(string) == 0){
		return(string);
	}
	
	if(string == "true"){
		string <- "TRUE";
	}
	
	if(string == "false"){
		string <- "FALSE";
	}
	
	#if string starts and ends with [] then assume JSON
	if(substr(string, 1, 1) == "["){
		if(!isValidJSON(string, TRUE)){
			stop("Looks like invalid JSON. Please validate at jsonlint.com.\n\n", string, "\n");
		}
		tryCatch({
			return(fromJSON(string))
		}, error=function(e){
			#should not happen anymore with isValidJSON()
			stop("Problem with JSON decoder: ", string, "\n\n");
		});
	}	

	#if string starts with { it might both be json or R code.	
	if(substr(string, 1, 1) == "{"){

		#The testforjson function guesses if this is a json string.
		if(testforjson(string)){

			#test if it is JSON
			if(!isValidJSON(string, TRUE)){
				stop("Looks like invalid JSON. Please validate at jsonlint.com.\n\n", string, "\n");
			}			
			
			#try to parse it
			tryCatch({
				return(fromJSON(string))
			}, error=function(e){
				#should not happen anymore with isValidJSON()
				stop("Problem with JSON decoder: ", string, "\n\n");
			});
		}
	}		
	
	#if string starts with encode:{ we assume opencpu encoding
	if(substr(string, 1, 8) == "encode:{"){
		#json object
		tryCatch({
			return(opencpu.decode(substring(string,8)))
		}, error=function(e){
			stop("unparsable opencpu encoding: ", string, "\n\n");
		});
	}		

	#if string starts with / assume a local file
	if(substr(string, 1, 1) == "/"){
		myfile <- tempfile();
		download.file(paste("http://localhost/R/store", string,"/rds", sep=""), myfile);
		return(readRDS(myfile));
	}		
	
	#if string starts with http:// or ftp:// assume a binary file
	if(substr(string, 1, 7) == "http://" || substr(string, 1, 7) == "ftp://"){
		#rda fie
		myfile <- tempfile();
		download.file(string, myfile);
		return(readRDS(myfile));
	}
	
	#check if it looks like a UUID
	myregex <- "^x[a-f0-9]{10}$"
	if(length(grep(myregex, string) > 0)){
		return(loadFromFileStore    (string));
	}
	
	#if config(eval.args) then eval code
	if(disable.eval == FALSE){
		#eval arguments
		return(parsewithbrackets(string));
	} else {
		#return existing object
		if(exists(string)){
			return(get(string));
		}	
		
		if(string == gsub("[^0-9e:.*/%+-]","",string) || string == "T" || string == "F" || string == "TRUE" || string == "FALSE" || string == "NA" || string == "NaN" || string == "Inf" || string == "-Inf"){
			#looks like a number or boolean
			return(eval(parse(text=string)));	
		}
		
		if(nchar(string) > 1 && substr(string, 1, 1) == "\"" && substr(string, nchar(string), nchar(string)) =="\""){
			#looks like a character string wrapped in double quotes
			return(substr(string, 2, nchar(string)-1));
		}
		
		if(nchar(string) > 1 && substr(string, 1, 1) == "\'" && substr(string, nchar(string), nchar(string)) =="\'"){
			#chracter string with single quotes
			return(substr(string, 2, nchar(string)-1));
		}
		
		stop("unparsable argument: ", string, "\n\nValid arguments are:\n- a numeric value, e.g. 3.1415 \n- a boolean, i.e. TRUE or FALSE \n- a character string enclosed in quotes, e.g \"My plot title\" \n- an existing R object (e.g. cars) \n- a JSON object that can be parsed by RJSONIO, e.g. [3,4,5,6] or {\"foo\":[1,2,3], \"bar\":true}. \n\nNote that custom code is not allowed for meta parameters or HTTP GET requests.");
	}
}
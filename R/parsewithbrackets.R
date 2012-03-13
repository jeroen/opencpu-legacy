#This code parses text and automatically wraps it in curly brackets when needed.

parsewithbrackets <- function(text){
	
  #strip trailing space
  text <- sub('[[:space:]]+$', '', text);
  text <- sub('^[[:space:]]+', '', text);
  
  #fix non unix eol
  text <- gsub("\r\n", "\n", text);
  text <- gsub("\r", "\n", text);
  
  #The case where code is already wrapped in brackets
  if(substring(text, 1,1) == "{" && substring(text, nchar(text)) == "}"){
	mycode <- try(parse(text=text), silent=TRUE);
	if(class(mycode) == "try-error"){
		stop("Unparsable argument: ", text);
	}
	return(mycode);
  } 
  
  #Else, first try to parse with brackets.
  parsed <- try(parse(text=paste("{",text, "}")), silent=TRUE);
  if(class(parsed) == "try-error"){
	  stop("Unparsable argument: ", text);
  }  
  
  #From this we infer if the brackets were needed.
  if(length(deparse(parsed[[1]])) > 3) return(parsed);
  	return(parse(text=text));
}
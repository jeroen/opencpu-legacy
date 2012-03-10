#This code parses text and automatically wraps it in curly brackets when needed.

parsewithbrackets <- function(text){
	
  #strip trailing space
  text <- sub('[[:space:]]+$', '', text);
  text <- sub('^[[:space:]]+', '', text);
  
  #fix non unix eol
  text <- gsub("\r\n", "\n", text);
  text <- gsub("\r", "\n", text);
  
  #test if it already wrapped
  if(substring(text, 1,1) == "{" && substring(text, nchar(text)) == "}"){
	return(parse(text=text));	  
  } 
  
  #try parse with brackets
  parsed <- parse(text=paste("{",text, "}"))
  if(length(deparse(parsed[[1]])) > 3) return(parsed);
  	return(parse(text=text));
}
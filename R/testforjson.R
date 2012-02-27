# TODO: Add comment
# 
# Author: jeroen
###############################################################################


testforjson <- function(mystring){
	
	#we are only interested in the begining
	mystring <- substring(mystring, 1, 100);
	
	#remove whitespace and escaped double quotes
	mystring <- gsub("[ \t\n\r]*", "", mystring);
	mystring <- gsub('\\"', "\\'", mystring, fixed=TRUE)
		
	#first part of the pattern needs to match {"some key": "some value"
	mypattern <- '^[{]".*":(true[,}]|false[,}]|null[,}]|([0-9eE+-.]+)[,}]|("[^"]*")[,}]|([{[]))';
	#cat(regmatches(mystring, regexpr(mypattern, mystring)), "\n")
	grepl(mypattern, mystring);
}

#test cases that should validate
#testforjson('{"foo":123}')
#testforjson('{"foo":true, "bar":false}')
#testforjson('{"foo":false, "bar":123}')
#testforjson('{"foo":null}')
#testforjson('{"foo":"bar"}')
#testforjson('{"f -oo":"b  123ar", sdfds}')
#testforjson('{"f *![}oo":"b  1}{)*23ar"}')
#testforjson('{"f *![}oo":"b  1}{)*\"23ar"}')
#testforjson('{"foo":[1 , 3, "bar"]}')
#testforjson('{"foo" : {"foo" : 123} }')
#testforjson('{"foo" : 123e5}')
#testforjson('{"foo" : -123+e5, "bar": false}')
#testforjson('{"foo" : -123+E5}')
#testforjson('{
#"foo":123
#}')

##
###test cases that should not validate
#testforjson('{"foo":trues}')
#testforjson('foo:123')
#testforjson('{{foo:123}')
#testforjson('{foo:123}')
#testforjson('{"foo":bar')
#testforjson('{"foo":}')
#testforjson('{"foo":234')
#testforjson('{"foo":234z123}')
#testforjson('{"foo": "234z123}')

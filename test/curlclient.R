# TODO: Add comment
# 
# Author: jeroen
###############################################################################


library(RCurl);
library(RJSONIO);
out <- getURL("http://www.stat.ucla.edu/~jeroen", verbose=T, customrequest="PUT");
out <- postForm(uri="http://www.stat.ucla.edu/~jeroen", foo="bar", .opts=list(verbose=T, customrequest="PUT"));

cat(getURL("http://127.0.0.1/echo?foo='bar'", verbose=T))
cat(getURL("http://127.0.0.1/echo?foo='bar'", verbose=T, customrequest="PUT"))
cat(getURL("http://127.0.0.1/echo?foo='bar'", verbose=T, customrequest="OPTIONS"))

cat(postForm(uri="http://127.0.0.1/echo", foo="bar", .opts=list(verbose=T)));
cat(postForm(uri="http://127.0.0.1/echo", foo="bar", .opts=list(verbose=T, customrequest="PUT")));

#GET POST PUT
system.time(eval(parse(text=getURL("http://127.0.0.1/R/ascii/stats/rnorm?n=100000"))));
system.time(fromJSON(getURL("http://127.0.0.1/R/json/stats/rnorm?n=100000")));
writeBin(getBinaryURL("http://127.0.0.1/R/rda/stats/rnorm?n=10&!seed=123"), "test.rda");
load("test.rda");

writeBin(getBinaryURL("http://127.0.0.1/R/rds/stats/rnorm?n=10&!seed=123"), "test2.rds");
newobj <- readRDS("test2.rds")


cat(postForm(uri="http://127.0.0.1/R/json/stats/rnorm", n="10", `!seed`='123'));
cat(postForm(uri="http://127.0.0.1/R/json/stats/rnorm", n="10", .opts=list(customrequest="PUT")));

#store (PUT) an object
print(postForm(uri="http://127.0.0.1/R/object/stats/rnorm", n="10", `!seed`='123', .opts=list(customrequest="PUT")));
print(postForm(uri="http://127.0.0.1/R/graph/ggplot2/qplot", x="rnorm(10000)", `!seed`='123', .opts=list(customrequest="PUT")));

#test url download
getURL("http://127.0.0.1/R/json/base/mean?x=http://127.0.0.1/store/tmp/2e039d5d6e335d9861d4d85526bff9d6")

#test local download
getURL("http://127.0.0.1/R/json/base/mean?x=/store/tmp/2e039d5d6e335d9861d4d85526bff9d6")

#test a call with no arguments:
getURL("http://127.0.0.1/R/json/utils/sessionInfo");

#remote plot
myfile <- tempfile();
writeBin(getBinaryURL("http://127.0.0.1/R/plot/ggplot2/qplot?x=rnorm(1000)&!seed=123"), myfile);
myplot <- readRDS(myfile);
print(myplot);



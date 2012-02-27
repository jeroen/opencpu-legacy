# TODO: Add comment
# 
# Author: jeroen
###############################################################################

library(RJSONIO);
library(foreign);
sessionInfo();

mydata <- read.spss("http://www.stat.ucla.edu/~jeroen/files/1991GS.sav", to.data.frame=T)
system.time(test <- toJSON(mydata));
system.time(test <- write.csv(mydata, "/dev/null"));

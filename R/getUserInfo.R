getUserInfo <- function(ACCESS_TOKEN){
	gitinfo <- getForm("https://api.github.com/user", .params=list(access_token=ACCESS_TOKEN));
	userinfo <- fromJSON(gitinfo);
	return(userinfo);
}
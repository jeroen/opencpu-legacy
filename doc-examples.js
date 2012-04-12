function variableDefined (name) {
    return typeof this[name] !== 'undefined';
}

$("button[data-example]")
	.addClass("btn btn-small btn-danger examplebutton")
	.prepend('<i class="icon-white icon-play"></i>  ')
	.click ( function() {
		var example = $(this).attr("data-example");
		var funname = "example_" + example;
		if(variableDefined(funname)){
			cleanAllParams();
			eval(funname + "()");
		} else {
			alert("Function '" + funname + "' not found!");
		}
	});

function gethashkey(type){
    var hashkey;
	try {
    	saveobject = jQuery.parseJSON($("#outputpre").text());
    	if(type == "undefined" || !type || type=="plot") {
    		hashkey = saveobject.graphs[0];
    	} else if(type=="object"){
    		hashkey = saveobject.object;
    	} else if(type=="file"){
    		var obj = saveobject.files;
    		for (var i in obj) {
    		    if (obj.hasOwnProperty(i) && typeof(i) !== 'function') {
    		    	hashkey = obj[i];
    		        break;
    		    }
    		}    		
    	} else return false;
    } catch (e) {
    	alert("Please first run a call with the /save output to generate some object/graphs/files.");
    	return false;
    }	
	if (hashkey == undefined){
		alert("Please first run a call with the /save output to generate some object/graphs/files.");
		return false;
	}    
	return hashkey;
}

function example_example(){
	alert("A red button indicates an example demo.");
}

function example_executefunction(){
	setRequest("POST", "/R/pub/stats/rnorm/json");
	addhttpparam("n", "15");
	addhttpparam("mean", "10");
	$("#submitajax").click();	
	$("#ajaxoutput").focus();
}

function example_readfunction(){
	setRequest("GET", "/R/pub/stats/rnorm/ascii");
	$("#submitajax").focus();
	$("#submitajax").click();	
}

function example_plotpng(){
	setRequest("POST", "/R/pub/ggplot2/qplot/png");
	addhttpparam("x", "speed");
	addhttpparam("y", "dist");
	addhttpparam("data", "cars");
	addhttpparam("geom", '["point", "smooth"]');
	$("#outputframe").hide();
	$("#ajaxoutput").hide();	
	setTimeout('$("#submitblank").click();', 500);	
}

function example_plotpdf(){
	setRequest("POST", "/R/pub/ggplot2/qplot/pdf");
	addhttpparam("x", "speed");
	addhttpparam("y", "dist");
	addhttpparam("data", "cars");
	addhttpparam("geom", '["point", "smooth"]');
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);
}

function example_plotsvg(){
	setRequest("POST", "/R/pub/ggplot2/qplot/svg");
	addhttpparam("x", "speed");
	addhttpparam("y", "dist");
	addhttpparam("data", "cars");
	addhttpparam("geom", '["point", "smooth"]');
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);	
}

function example_listpub(){
	setRequest("GET", "/R/pub");
	$("#submitajax").click();
}

function example_liststats(){
	setRequest("GET", "/R/pub/stats");
	$("#submitajax").click();
}

function example_listpuboutputs(){
	setRequest("GET", "/R/pub/datasets/iris");
	$("#submitajax").click();	
}

function example_getobject1(){
	setRequest("GET", "/R/pub/stats/lm/ascii");
	$("#submitajax").click();		
}

function example_getobject2(){
	setRequest("GET", "/R/pub/datasets/iris/json");
	$("#submitajax").click();		
}

function example_getobject3(){
	setRequest("GET", "/R/pub/datasets/iris/csv");
	$("#submitajax").click();		
}

function example_callwithsave(){
	setRequest("POST", "/R/pub/stats/rnorm/save");
	addhttpparam("n", "15");
	addhttpparam("mean", "10");
	$("#submitajax").click();	
}

function example_callsweave(){
	setRequest("POST", "/R/pub/utils/Sweave/save");
	addhttpparam("file", "system.file('Sweave','Sweave-test-1.Rnw', package='utils')");
	$("#submitajax").click();		
}

function example_manyplots(){
	setRequest("POST", "/R/pub/base/identity/save");
	addhttpparam("x", "plot(lm(speed~dist, cars))");
	$("#submitajax").click();
}

function example_carslm(){
	setRequest("POST", "/R/pub/stats/lm/save");
	addhttpparam("formula", "speed~dist");
	addhttpparam("data", "cars");
	$("#submitajax").click();
}

function example_getlm(){
	setRequest("GET", "/R/tmp/xfafaa3105c/print");
	$("#submitajax").click();
}

function example_lmsummary(){
	setRequest("POST", "/R/pub/base/summary/print");
	addhttpparam("object", "xfafaa3105c");
	$("#submitajax").click();	
}

function example_lmplot(){
	setRequest("POST", "/R/pub/graphics/plot/save");
	addhttpparam("x", "xfafaa3105c");
	$("#submitajax").click();	
}

function example_storefun(){
	setRequest("POST", "/R/pub/base/identity/save");
	addhttpparam("x", "function(n) {mydata <- rnorm(n); print(lattice::histogram(mydata)); return(n);} ");
	$("#submitajax").click();		
}

function example_readfun(){
	setRequest("GET", "/R/tmp/x82745ce753/ascii");
	$("#submitajax").click();		
}

function example_callfun(){
	setRequest("POST", "/R/tmp/x82745ce753/png");
	addhttpparam("n", "1000");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_listusers(){
	setRequest("GET", "/R/user");
	$("#submitajax").click();		
}

function example_listuserstores(){
	setRequest("GET", "/R/user/jeroenooms");
	$("#submitajax").click();		
}

function example_liststoreobjects(){
	setRequest("GET", "/R/user/jeroenooms/demostore");
	$("#submitajax").click();		
}

function example_readuserobject(){
	setRequest("GET", "/R/user/jeroenooms/demostore/myobject/ascii");
	$("#submitajax").click();		
}

function example_calluserfunction(){
	setRequest("POST", "/R/user/jeroenooms/demostore/myobject/save");
	addhttpparam("n", "1234");
	$("#submitajax").click();		
}

function example_argumentprimitive(){
	setRequest("POST", "/R/pub/base/list/json");
	addhttpparam("foo", "3.1415e-4");
	addhttpparam("bar", '"AYBABTU"');
	addhttpparam("baz", "TRUE");
	$("#submitajax").click();		
}

function example_argumentjson(){
	setRequest("POST", "/R/pub/stats/sd/json");
	addhttpparam("x", "[1,2,3,4,5,6,7,8,9]");
	$("#submitajax").click();	
}

function example_argumentcode(){
	setRequest("POST", "/R/pub/base/identity/json");
	addhttpparam("x", "foo <- 123; bar <- 456; foo + bar;");
	$("#submitajax").click();	
}

function example_argumenturl(){
	setRequest("POST", "/R/pub/graphics/plot/save");
	addhttpparam("x", "http://127.0.0.1/R/pub/datasets/cars/rds");
	$("#submitajax").click();	
}

function example_uploadfilerds(){
	setRequest("POST", "/R/pub/base/identity/json");
	addhttpfile("x");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
}

function example_uploadfilefile(){
	setRequest("POST", "/R/pub/utils/read.csv/save");
	addhttpfile("!file:file");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
}

function example_uploadfilecopy(){
	setRequest("POST", "/R/pub/base/identity/json");
	addhttpfile("!copy:myfilename");
	addhttpparam("x", "read.csv(myfilename)");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
}

function example_getplotpng(){
	hashkey = gethashkey("plot");
	if(!hashkey) return;
	setRequest("GET", "/R/tmp/" + hashkey + "/png");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_getplotpnglarge(){
	hashkey = gethashkey("plot");
	if(!hashkey) return;
	setRequest("GET", "/R/tmp/" + hashkey + "/png");
	addhttpparam("!width", "1000");
	addhttpparam("!height", "600");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_getplotpdf(){
	hashkey = gethashkey("plot");
	if(!hashkey) return;
	setRequest("GET", "/R/tmp/" + hashkey + "/pdf");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_getplotsvg(){
	hashkey = gethashkey("plot");
	if(!hashkey) return;
	setRequest("GET", "/R/tmp/" + hashkey + "/svg");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_carsjson(){
	setRequest("GET", "/R/pub/datasets/cars/json");
	$("#submitajax").click();	
}

function example_carsencode(){
	setRequest("GET", "/R/pub/datasets/cars/encode");
	$("#submitajax").click();	
}

function example_carscsv(){
	setRequest("GET", "/R/pub/datasets/cars/csv");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_carstable(){
	setRequest("GET", "/R/pub/datasets/cars/table");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_carsascii(){
	setRequest("GET", "/R/pub/datasets/cars/ascii");
	$("#submitajax").click();	
}

function example_carsrds(){
	setRequest("GET", "/R/pub/datasets/cars/rds");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_carsrda(){
	setRequest("GET", "/R/pub/datasets/cars/rda");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_outputfile(){
	setRequest("POST", "/R/pub/base/system.file/file");
	addhttpparam("...", '"DESCRIPTION"');
	addhttpparam("package", '"grid"');
	$("#submitajax").click();	
}

function example_savefile(){
	setRequest("POST", "/R/pub/utils/write.csv/save");
	addhttpparam("x", "cars");
	addhttpparam("file", '"mycsvfile.csv"');
	$("#submitajax").click();		
}

function example_getstoredfile(){
	hashkey = gethashkey("file");
	if(!hashkey) return;
	setRequest("GET", "/R/tmp/" + hashkey + "/bin");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_helptext(){
	setRequest("GET", "/R/pub/stats/glm/help/text");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_helppdf(){
	setRequest("GET", "/R/pub/stats/glm/help/pdf");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);	
}

function example_helphtml(){
	setRequest("GET", "/R/pub/stats/glm/help/html");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);	
}

function example_helpjson(){
	setRequest("GET", "/R/pub/stats/glm/help/json");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);	
}

function example_summarycars(){
	setRequest("POST", "/R/pub/base/summary/print");
	addhttpparam("object", 'cars');
	$("#submitajax").click();		
}

function example_login(){
	setRequest("GET", "/auth/login");
	$("#outputframe").hide();
	$("#ajaxoutput").hide();		
	setTimeout('$("#submitblank").click();', 500);		
}

function example_logout(){
	setRequest("GET", "/auth/logout");
	$("#submitajax").click();		
}

function example_getclientid(){
	setRequest("POST", "/R/pub/base/identity/ascii");
	addhttpparam("x", 'config("github.clientid")');
	$("#submitajax").click();		
}

function example_gethome(){
	setRequest("GET", "/home");
	$("#submitajax").click();		
}

function example_installpackage(){
	setRequest("POST", "/R/pub/utils/install.packages/save");
	addhttpparam("pkgs", '"memoise"');
	$("#submitajax").click();	
}

function example_copypackage(){
	var myhashkey = gethashkey("file");
	setRequest("PUT", "/home/memoise");
	addhttpparam("package", myhashkey);
	$("#submitajax").click();		
}

function example_getpackage(){
	setRequest("GET", "/home/memoise");
	$("#submitajax").click();		
}

function example_deletepackage(){
	setRequest("DELETE", "/home/memoise");
	$("#submitajax").click();		
}

//STORE

function example_createstore(){
	setRequest("PUT", "/home/demostore");	
	$("#submitajax").click();	
}

function example_createobject(){
	setRequest("POST", "/R/pub/base/identity/save");
	addhttpparam("x", "function(x) {sum(x^2)}");
	$("#submitajax").click();	
}

function example_copytostore(){
	var myhashkey = gethashkey("object");	
	setRequest("PUT", "/home/demostore/myfunction");
	addhttpparam("object", myhashkey);	
	$("#submitajax").click();
}

function example_callhomefunction(){
	var username = "jeroenooms";
	setRequest("POST", "/R/user/" + username + "/demostore/myfunction/json");
	addhttpparam("x", "[1,2,3,4,5]");	
	$("#submitajax").click();
}

function example_getobjectfromstore(){
	setRequest("GET", "/home/demostore/myfunction");
	setTimeout('$("#submitblank").click();', 500);			
}

function example_getwholestore(){
	setRequest("GET", "/home/demostore");
	setTimeout('$("#submitblank").click();', 500);		
}

function example_deleteobject(){
	setRequest("DELETE", "/home/demostore/myfunction");
	$("#submitajax").click();	
}

function example_deletestore(){
	setRequest("DELETE", "/home/demostore");
	$("#submitajax").click();		
}
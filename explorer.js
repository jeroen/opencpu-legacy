$(document).ready(function() {
  //something for open mHealth
  if(document.location.hostname.slice(-6) == "omh.io"){
	  $("#urlvalue").val(document.location.protocol + "//" + document.location.hostname + "/app/config/read"); 
  }	else if(document.location.hostname.slice(-11) == "opencpu.org"){
	  $("#urlvalue").val(document.location.protocol + "//" + document.location.hostname + "/R/pub"); 
  }	else {
	  $("#urlvalue").val(document.location.href);
  }
  populateCookieTable();
  updateCookieWarning();
  
});
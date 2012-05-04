var userapps = function(){
	$.ajax({
		url: "/userapps/index.json",
		cache: false,
		dataType: "json",
		success: function(data, textStatus, jqXHR){
			for(var i = 0; i < data.length; i++){
				if(data[i] != "index.json"){
					userinfo(data[i]);
				}
			}
		}
	});	
};

var userinfo = function(username){
	$.ajax({
		url: "https://api.github.com/users/" + username,
		success: createuserlink,
		cache: true,
		dataType: "jsonp"
	});		
};

var createuserlink = function(response){
	var data = response.data;
	var username = data.login;
	var avatarlink = "https://secure.gravatar.com/avatar/" + data.gravatar_id + "?s=100";

	$.ajax({
		url: "/userapps/" + username + "/index.json",
		cache: false,
		dataType: "json",
		success: avatarclosure(username, avatarlink)
	});		
};

var avatarclosure = function(username, avatarlink){
	var mycb = function(data, textStatus, jqXHR){
		var appshtml = '';
		for(var i = 0; i < data.length; i++){
			if(data[i] != "index.json"){
				appshtml = appshtml + '<li><a href="/userapps/' + username + '/' + data[i] + '">' + data[i] + '</a></li>';
			}
		}
		
		$("#appsrow").append(
			'<div class="userdiv span2">' +
			'<a href="/userapps/'+ username +'"><img class="avatar" src="' + avatarlink +'" alt="' + username +' " /></a>' +
			'<ul class="nav nav-tabs nav-stacked"><li class="nav-header">' + username + '</li>' + appshtml + '</ul>' + 
			'</div>'
		);				
	};
	return mycb;
};

userapps();


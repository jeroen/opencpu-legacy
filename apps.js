function userapps(){
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
}

function userinfo(username){
	$.ajax({
		url: "https://api.github.com/users/" + username,
		jsonpCallback: 'createuserlink',
		cache: true,
		jsonp: 'callback',
		dataType: "jsonp"
	});		
}

function createuserlink(response){
	var data = response.data;
	var username = data.login;
	var avatarlink = "http://www.gravatar.com/avatar/" + data.gravatar_id + "?s=100";
	
	$.ajax({
		url: "/userapps/" + username + "/index.json",
		cache: false,
		dataType: "json",
		success: avatarclosure(username, avatarlink)
	});		
}

function avatarclosure(username, avatarlink){
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
}

userapps();


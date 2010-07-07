// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function handle_cached_user() {
	var login_cookie = readCookie('login');
	/*
	var divs = getObjectsByTagAndClass('div','logged_in');
	  if (divs != undefined && divs != null)
	  {
	    for (var i = 0; i < divs.length; i++)
	    {
	      //if (divs[i].id == 'logged_in')
	        divs[i].style.display = 'block';        
	    }
	  }
	*/
    var logged_in = document.getElementsByClassName('logged_in');
    var logged_out = document.getElementsByClassName('logged_out');
    if(login_cookie == null) {
		//User not logged in
      	for (var i = 0; i < logged_in.length; i++)
		    {
		        logged_in[i].style.display = 'none';        
		    }
			for (var i = 0; i < logged_out.length; i++)
			    {
			        logged_out[i].style.display = 'inline';        
			    }
    } else {
		//User logged in
	   for (var i = 0; i < logged_in.length; i++)
	    {
	        logged_in[i].style.display = 'inline';        
	    }
		for (var i = 0; i < logged_out.length; i++)
		    {
		        logged_out[i].style.display = 'none';        
		    }
		handle_menu(login_cookie);
    }
	
}

function handle_menu(login_cookie) {
	
	//var login_cookie = readCookie('login');
	
	document.getElementById('menu_username').firstChild.nodeValue=login_cookie;
	
	
}
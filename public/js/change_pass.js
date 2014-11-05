var pass_form = document.getElementById("chpass_form");

pass_form.addEventListener("onsubmit", check_password_match, true);

function check_password_match(form){
	var new_pass = document.getElementById("new_password");
	var pass_confirm = document.getElementById("password_confirm");
	if ( new_pass == pass_confirm){
		if (new_pass.length > 5){
			pass_form.submit();
		}else{
			alert("Your password is too short.");
		}
	}else{
		alert("Your passwords did not match");
	} //TODO: Replace these with nicer-looking alerts...maybe foundation has something??
	return false; //this should stop submits
}

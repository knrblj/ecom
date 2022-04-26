let cookiearr = {};
document.cookie.split(";").forEach(function(cook)
{
	let [key,value]=cook.split("=");
	cookiearr[key.trim()]=value;
})

function sessionValidate()
{
	if(cookiearr['email']==null || cookiearr['email']=='')
		window.location='login.html';
	else
		console.log(cookiearr['email']);
		
	if(cookiearr['email']==="admin@gmail.com")
		document.getElementById("admin").style.display="block";
}

function logout()
{
    document.cookie ="email=;";
    window.location.href="home.jsp";

}
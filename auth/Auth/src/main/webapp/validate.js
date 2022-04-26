
//Creates all the cookies in array format..
let cookie = {};
document.cookie.split(";").forEach(function(cook)
{
	let [key,value]=cook.split("=");
	cookie[key.trim()]=value;
})
if(cookie['email']!=null)
{
	email=atob(cookie['email'])
	
	var res="";
	for(var i=0;i<email.length;i++)
	{
		res+=String.fromCharCode(email.charAt(i).charCodeAt(0)-4);
	}
	cookie['email']=res
}
console.log(cookie['email']);

function loginCookie()
{
	if(cookie['msg']=='emailnotfound')
	{
		document.getElementById('loginres').innerHTML="<div class='alert alert-danger'>Email address Not found</div>";
	}
	else if(cookie['msg']=='passwordwrong')
	{
		document.getElementById('loginres').innerHTML="<div class='alert alert-danger'>Password wrong</div>";
	}
}

//check the cokie is set for userExists are not
function checkCookie()
{
	if(cookie['userExists']=='true')
	{
		document.getElementById("cookiestatus").innerHTML="<div class=\"alert alert-danger\">Email id alreay exists</div>";
	}
}
//ends...

//checks the user is logeedin or not --- session alidation
function sessionValidate()
{
	if(cookie['email']==null || cookie['email']=='')
		window.location='login.html';
	
	
	if(cookie['role']==="root" || cookie['role']=='admin')
	{
		document.getElementById("admin").style.display="block";
		document.getElementById("order").innerHTML="All orders";
	}
	if(cookie['role']==="root")
	{
		document.getElementById("usersbutton").style.display="block";
	}
	updateCart(0);
}
//ends...

//validation for the registration page...
function validate()
{
	var name=document.getElementById("name").value;
	var email=document.getElementById("email").value;
	var phone=document.getElementById("phone").value;
	var password=document.getElementById("password").value;
	var cpassword=document.getElementById("cpassword").value;
	
	//console.log(name+" "+email+" "+phone+" "+password+" "+cpassword);
	var count=0;
	if(name==="")
		document.getElementById("nameres").innerHTML="<div class='text-danger''>* Please Enter name<div>";
	else if(name.length<=3)
		document.getElementById("nameres").innerHTML="<div class='text-danger''>* Name should be greather than 3 characters<div>";
	else
	{
		document.getElementById("nameres").innerHTML="";
		count++;
	}
	
	if(email==="")
		document.getElementById("emailres").innerHTML="<div class='text-danger''>* Please Enter email<div>";
	else if(!check)
		document.getElementById("emailres").innerHTML="<div class='text-danger''>* Email id already exists<div>";
	else
	{
		document.getElementById("emailres").innerHTML="";		
		count++;
	}

		
	if(phone==="")
		document.getElementById("phoneres").innerHTML="<div class='text-danger''>* Please Enter Phone Number<div>";
	else if(phone.length!=10)
		document.getElementById("phoneres").innerHTML="<div class='text-danger''>* Number is Invalid<div>";
	else
	{
		document.getElementById("phoneres").innerHTML="";
		count++;
	}
		
	if(password==="")
		document.getElementById("passwordres").innerHTML="<div class='text-danger''>* Please Enter password<div>";
	else if(password.length<=6)
		document.getElementById("passwordres").innerHTML="<div class='text-danger''>* Password should be greather than 6 characters<div>";
	else
	{
		document.getElementById("passwordres").innerHTML="";
		count++;
	}
		
	if(cpassword==="")
		document.getElementById("cpasswordres").innerHTML="<div class='text-danger''>* Please Enter confirm password<div>";
	else if(cpassword!=password)
		document.getElementById("cpasswordres").innerHTML="<div class='text-danger''>* Confrim password should be equal with password<div>";
	else
	{
		document.getElementById("cpasswordres").innerHTML="";
		count++;
	}
	//console.log(count);	
	if(count===5)
		return true;
	return false;
}
//ends...


//validate the login form
function loginValidate()
{
	let email=document.getElementById('email').value;
	let password=document.getElementById('password').value;
	let count=0;
	
	if(email==="")
		document.getElementById("emailres").innerHTML="<div class='text-danger''>* Please Enter email<div>";
	else
	{
		document.getElementById("emailres").innerHTML="";
		count++;
	}
	
	if(password==="")
		document.getElementById("passwordres").innerHTML="<div class='text-danger''>* Please Enter password<div>";
	else if(password.length<=6)
		document.getElementById("passwordres").innerHTML="<div class='text-danger''>* Password should be greather than 6 characters<div>";
	else
	{
		document.getElementById("passwordres").innerHTML="";
		count++;
	}
	
	if(count==2)
		return true;
	
	return false;
}
//hello

///ajax to check the user already exists are not in register page
var check=false;
function check_user(value)
{
	var xhttp=new XMLHttpRequest();
	var url="checkUser.jsp?email="+value;
	xhttp.onreadystatechange=function()
	{
		if(this.status==200 && this.readyState==4)
		{
			var text=this.responseText;
			text=text.trim();
			if(text==="false")
			{
				document.getElementById("emailres").innerHTML="<div class='text-danger''>* Email id already exists<div>";
				check=false;
			}
			else
			{
				document.getElementById("emailres").innerHTML="";
				check=true;
			}
		}
	};
	
	xhttp.open("GET",url,true);
	xhttp.send();
}

//logout function
function logout()
{
    document.cookie = "role=; expires=Thu, 01 Jan 1970 00:00:00 UTC;  path=/Auth";
    document.cookie = "email=; role=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/Auth";
    window.location.href="home.jsp";
}



///getting the value of the cart products
function updateCart(value)
{
	//console.log("hello");
	var xhttp=new XMLHttpRequest();
	var url="Cart";
	xhttp.open("POST",url,true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send("product_id="+value);
	xhttp.onreadystatechange = function ()
	{
		if(this.readyState=4 && this.status==200)
		{
			
			 var jsonval=JSON.parse(this.response);
			 var cartval=jsonval.cartcount;
			 //console.log(this.response);
			 document.getElementById('cartcount').innerHTML=cartval;
		}
	}
}


//getting cart quantity, can we able to order or not
function cartQunantity()
{
	//console.log("hello");
	var xhttp=new XMLHttpRequest();
	var url="ValidateCartQuantity"
	xhttp.open("POST",url,true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send("email="+cookie['email'])
	xhttp.onreadystatechange = function ()
	{
		if(this.readyState=4 && this.status==200)
		{
			 var jsonval=JSON.parse(this.response);
			 var len=0;
			 for(var key in jsonval)
			 {
				if(jsonval[key]=='0')
				{
					document.getElementById("result").innerHTML="<div class='alert alert-danger'>The product <b>"+key+"</b> is not available with that quantity.. </div>";
					document.getElementById("checkoutbutton").style.display="none";
				}
				len++;
			 }
			 if(len===0)
			 		document.getElementById("checkoutbutton").style.display="none";

		}
	}
}




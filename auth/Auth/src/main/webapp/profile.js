function profFunction(value)
{
	document.getElementById('otp').type='hidden';
	document.getElementById('sendButton').style.display='none';
	document.getElementById('data').innerHTML=value;
	document.forms['updateForm']['type'].value=value;
	if(value=='email')
	{
		document.getElementById('datainput').type='email';
		document.getElementById("updateForm").action="";
		document.getElementById('sendButton').style.display='block';
	}
	else if(value=='password')
		document.getElementById('datainput').type=value;
	else if(value=='phone')
		document.getElementById('datainput').type='number';
	else
		document.getElementById('datainput').type='text';			
}

function openAddressForm(address_id)
{
	document.forms['updateAddressForm']['address_id'].value=address_id;
	document.getElementById("updateAddressForm").style.display="block";
}
function closeForm()
{
	document.getElementById("updateAddressForm").style.display="none";
}

function buttondisable()
{
	var data=document.getElementById('datainput').value;
	var phone=document.getElementById('phone').value;
	if(data.length<=3)
	{
		alert("Enter email");
		return false;
	}
	$.ajax({
	method:'GET',
	url:'OtpServlet?data='+data+"&phone="+phone,
	async: false,
	success:function(response){
		console.log(response);
	}
	})
	document.getElementById("sendButton").disabled = true;
	document.getElementById('otp').type='number';
	document.getElementById("updateForm").action="tester.jsp";
}
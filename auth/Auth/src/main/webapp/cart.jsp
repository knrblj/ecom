<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<title>Cart</title>
<style>
        #loader {
            border: 12px solid #f3f3f3;
            border-radius: 50%;
            border-top: 12px solid #444444;
            width: 70px;
            height: 70px;
            animation: spin 1s linear infinite;
        }
          
        @keyframes spin {
            100% {
                transform: rotate(360deg);
            }
        }
          
        .center {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            margin: auto;
        }
    </style>

</head>
<body onload="sessionValidate()">
	<div id="loader" style="display:none;"></div>
	<div class="container">
	<div class="text-center text-primary"><h1>Cart</h1></div>
	<!-- Menu bar Starts -->
		<nav class="navbar navbar-inverse">
		  <div class="container-fluid">
		    <div class="navbar-header">
		      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span> 
		        <span class="icon-bar"></span>
		      </button>
		      <a class="navbar-brand" href="home.jsp">ECOM WEB</a>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		      <ul class="nav navbar-nav" style="float: right;">
		        <li ><a href="home.jsp">Home</a></li>
		        <li id="admin" style="display:none;"><a href="add.jsp">Manage Products</a></li>
		        <li><a href="orderslist.jsp" id="order">My orders</a></li>
		        <li><a href="profile.jsp">My profile</a></li>
		        <li id="usersbutton" style="display:none;"><a href="users.jsp">Users</a></li>
		        <li class="active"><a href="cart.jsp">Cart  <span class="badge"  id="cartcount">0</span></a></li>
		        <li><a href="" onclick="logout()">Logout</a></li>
		      </ul>
		    </div>
		  </div>
		</nav>
		<!-- Menu bar Ends... -->
		<div id="result"></div>
		<%
		if(session.getAttribute("cart")!=null && session.getAttribute("cart").equals("delete"))
		{
			out.println("<div class='alert alert-success'>Deleted Successfully..</div>");
			session.setAttribute("cart",null);
		}
		%>
		
		<table class="table table-hover">
		<thead>
		<tr>
		<td>Product</td>
		<td>Quantity</td>
		<td>Price</td>
		<td>Delete</td>
		</tr>
		</thead>
		<%
		String email=null;
		Cookie cookie[]=request.getCookies();
		if(cookie.length!=0)
		{
			for(int i=0;i<cookie.length;i++)
			{
				if(cookie[i].getName().equals("email"))
					email=cookie[i].getValue();
			}
		}
		email=Encryption.dec(email);
		String query="SELECT product_name,\n"+
				"sum(quantity) as quantity ,\n"+
				"product_cost*sum(quantity) as total \n"+
				",product_id \n"+
				",cart.id \n"+
				"from products,cart \n"+
				"where cart.product_id=products.id \n"+
				"and \n"+
				"user_id=(SELECT id from users where email=?) \n"+
				"GROUP by product_id;";
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1,email);
		ResultSet rs=stmt.executeQuery();
		String product="";
		double price=0;
		while(rs.next())
		{
			product+=rs.getString(4)+"|q|"+rs.getString(2)+"|q|"+rs.getString(1)+"|q|"+rs.getString(3)+" ";
			price+=Double.parseDouble(rs.getString(3));
			out.println("<tr>");
			out.println("<td>"+rs.getString(1)+"</td>");
			out.println("<form id='testForm' action='CartQuantityUser' method='post'>");
			out.print("<input type='hidden' name='order_id' value='"+rs.getString(5)+"'>");
			out.println("<td><input style='width:50px;' min=1 type='number' name='quantity' id='quantity"+rs.getString(5)+"' value='"+rs.getString(2)+"' readonly>");
			out.println("<button id='ok"+rs.getString(5)+"' style='display:none;'><span class='glyphicon glyphicon-ok'></span></button></form>");
			out.println("<button id='remove"+rs.getString(5)+"' value='"+rs.getString(5)+"' style='display:none;' onclick='hideOption(this.value)'><span class='glyphicon glyphicon-remove' ></span></button></form>");
			out.println("<button id='test"+rs.getString(5)+"' value='"+rs.getString(5)+"' onclick='openEdit(this.value)'><span class='glyphicon glyphicon-edit'></span></button>");
			out.println("</td>");
			out.println("<td>"+rs.getString(3)+" /- </td>");
			out.println("<td><button value="+rs.getString(4)+" onclick='cartDeleteFun(this.value)' class='btn btn-danger'><span class='glyphicon glyphicon-trash'></span></button></td>");
			out.println("</td>");
		}
		con.close();
		%>
		</table>
		
		<div id="checkoutbutton"><center><button  class="btn btn-success" onclick="openCartForm()">CheckOut</button></center></div>
		
		<!-- Address form -->
		<div class="col-lg-3"></div>
		<div class="form col-lg-6" id="formopen" style="display:none;">
		<form action="" onsubmit="return orderFunc();">
			<input type="hidden" class="form-control" value="<% out.println(product);%>" id="product" name="product">
			<div class="form-group">
			<input type="text" class="form-control" placeholder="Full Name(Required)*" id="name" name="name" required>
		</div>
		
		<div class="form-group">
			<input type="number" class="form-control" placeholder="Phone Number(Required)*" id="phone" name="phone" required>
		</div>
		
		<div class="form-group">
			<input type="text" class="form-control" placeholder="House No,Building Name(Required)*" id="house" name="house" required>
		</div>
		
		<div class="form-group row">
			<div class="col-xs-4"><input type="text" class="form-control" placeholder="State(Required)*" id="state" name="state" required></div>
			<div class="col-xs-4"><input type="text" class="form-control" placeholder="city(Required)*" id="city" name="city" required></div>
			<div class="col-xs-4"><input type="number" class="form-control" placeholder="Pincode(Required)*" id="pincode" name="pincode" required></div>
		</div>
		
		<div class="form-group">
			<input type="submit" value="Place Order" class="form-control btn-success" id="submit">
		</div>
		<div class="form-group"><a href="#" class="btn btn-danger" onclick="closeForm()">Close The From</a></div>
		</form>
		
		</div>
		<div class="col-lg-3"></div>
		
	</div>
	<!-- form ends -->
		
		
	</div>
	<script src="validate.js"></script>
	
	
	<script type="text/javascript">
	
	cartQunantity();  //check the function of cart qunatity
	
	function openEdit(value)
	{
		document.getElementById('test'+value).style.display='none';
		document.getElementById('ok'+value).style.display='';
		document.getElementById('remove'+value).style.display='';
		document.getElementById('quantity'+value).readOnly= false;
	}
	function hideOption(value)
	{
		document.getElementById('test'+value).style.display='';
		document.getElementById('ok'+value).style.display='none';
		document.getElementById('remove'+value).style.display='none';
		document.getElementById('quantity'+value).readOnly= true;
	}
	
	function CartQuantityUpdate()
	{
	  document.getElementById("testForm").submit();
	}
	
	
	function cartDeleteFun(value)
	{
		var xhttp=new XMLHttpRequest();
		window.location.href="cartDelete.jsp?id="+value+"&email="+cookie['email'];
	}
	function openCartForm()
	{
		document.getElementById("formopen").style.display="block";
	}
	function closeForm()
	{
		document.getElementById("formopen").style.display="none";
	}
	function orderFunc()
	{
		document.getElementById("loader").style.display="block";
		var product=document.getElementById("product").value;
		var name=document.getElementById("name").value;
		var phone=document.getElementById("phone").value;
		var house=document.getElementById("house").value;
		var state=document.getElementById("state").value;
		var city=document.getElementById("city").value;
		var pincode=document.getElementById("pincode").value;
		var productarr=product.trim().split(" ");
		for(var x of productarr)
		{
			var product_id=x.split("|q|")[0];
			var quantity=x.split("|q|")[1];
			var product=x.split("|q|")[2];
			var price=x.split("|q|")[3];
			//console.log(product_id+" "+product+" "+quantity+" "+price);
			
			//window.location.href="ordersave.jsp?product_id="+product_id+"&product="+product+"&quantity="+quantity+"&price="+price+"&name="+name+"&phone="+phone+"&house="+house+"&state="+state+"&city="+city+"&pincode="+pincode;
			console.log("hello");
			var xhttp=new XMLHttpRequest();
			var url="ordersave.jsp?product_id="+product_id+"&product="+product+"&quantity="+quantity+"&price="+price+"&name="+name+"&phone="+phone+"&house="+house+"&state="+state+"&city="+city+"&pincode="+pincode;
			xhttp.open("GET",url,true);
			//xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			xhttp.send();
			xhttp.onreadystatechange = function ()
			{
				if(this.readyState=4 && this.status==200)
				{
					console.log(this.responseText);
				}
				else
				{
					console.log("wait");
				}	
			
			}
		}
		for(var x of productarr)
		{
			var product_id=x.split("|q|")[0];
			var xhttp=new XMLHttpRequest();
			var url="cartDelete.jsp?id="+product_id;
			xhttp.open("GET",url,false);
			xhttp.send();
			xhttp.onreadystatechange = function ()
			{
				if(this.readyState=4 && this.status==200)
				{
					console.log(this.responseText);
				}
			}
		}
		window.location.href="home.jsp"; 
		return false;
	}
	</script>
</body>
</html>
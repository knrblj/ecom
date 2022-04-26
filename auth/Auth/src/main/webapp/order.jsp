<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,Backend.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order the Product</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body onload="sessionValidate()">

	<div class="text-center text-success"><h1>Checkout Page</h1></div>
	<div class="container">
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
				 <li><a href="cart.jsp">Cart  <span class="badge"  id="cartcount">0</span></a></li>
		        <li><a href="" onclick="logout()">Logout</a></li>
		      </ul>
		    </div>
		  </div>
		</nav>
		<!-- Menu bar Ends... -->
	</div>
	<% 
	String id=request.getParameter("id");
	if(session.getAttribute("address")!=null && session.getAttribute("address").equals("saved"))
			{
				out.println("<div class='container alert alert-success'>Your Address Saved Successfully</div>");
				session.setAttribute("address",null);
			}
	%>
	<%
		
		
		if(id==null || id.equals(""))
			response.sendRedirect("home.jsp");
		
		String product="";
		String price="";
		String image="";
		String email=null;
		int user_id=0;
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
		//out.println(email);
		int addreslen=0;
		ResultSet addres=null;
		Connection con=null;
		String addQuery="select * from user_address where user_id=(select id from users where email=?)";
		try
		{
		Class.forName("com.mysql.cj.jdbc.Driver");
		con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		String query="select * from products where id=?";
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setInt(1,Integer.valueOf(id));
		ResultSet rs=stmt.executeQuery();
		int rscount=0;
		while(rs.next())
		{
			rscount++;
			product=rs.getString(2);
			price=rs.getString(4);
			image=rs.getString(5);
		}
		if(rscount==0)
			response.sendRedirect("home.jsp");
		
		///Reterving address from the database
		
		PreparedStatement st=con.prepareStatement(addQuery);
		st.setString(1,email);
		addres=st.executeQuery();
		while(addres.next())
		{
			addreslen++;
			user_id=addres.getInt(2);
		}
		}
		catch(Exception e)
		{
			out.println(e);
		}		
	%>
	<div class="container">
	<center><img src='<%out.println(image);%>' class="img-rounded" width="200px" height="250px"></center>
	<h2 class="text-center"><%out.println(product); %></h2>
	<h4 class="text-center"> <b>RS. <%out.println(price); %> /- only</b></h4>
	<center>
	<div ><form class="form-inline">
	<label>Qunatity</label>
	<input type="number" id="quantity" name="quantity" value=1 class="form-control" max=10 min=1 onchange="quantityFunc(this.value)">
	</form></div>
	</center>
	<center>
	<div style="margin:3px;"><button class="btn btn-success" onclick="openAddress()">Checkout With Saved Address</button></div>
	<div style="margin:3px;"><button class="btn btn-success" onclick="openNewAddress()">Checkout With New Address</button></div>
	</center>
	</div>
	
	<!-- Address for already saved -->
		<div id="savedAddress" style="display:none;">
		<div class="text-center"><b><h2>Saved Address</h2></b></div>
		
		<!-- If Already addresss are saved it will show -->
		
		<% 
		if(addreslen!=0)
		{
			PreparedStatement st=con.prepareStatement(addQuery);
			st.setString(1,email);
			addres=st.executeQuery();
			out.println("<div class='col-lg-3'></div>");
			out.println("<div class='form-group col-lg-6'>");
			out.println("<form id='saveform' onsubmit='return checkbox();' action='defaultSave.jsp' name='defaultsaveForm'>");
			out.println("<div style='border:1px solid; padding:2px;'>");
			int i=1;
			out.println("<input type='hidden' class='form-control'  value="+id+" id='product_id' name='product_id' >");
			out.println("<input type='hidden' class='form-control'  value="+product+" id='product' name='product' >");
			out.println("<input type='hidden' class='form-control'  value="+price+" id='price' name='price' >");
			out.println("<input type='hidden' class='form-control'  value="+user_id+" id='user_id' name='user_id'>");
			out.println("<input type='hidden' class='form-control'  value='1' id='quantity' name='quantity'>");
			while(addres.next())
			{
				out.println("<input type='radio' value='"+ addres.getInt(1) +"'  id='address"+ i+"' name='address' class='form-checkbox-input'>");
				out.println("<label class='form-checkbox-label' for='address"+i+"'>"+addres.getString(3)+" "+addres.getString(4)+" "+addres.getString(5)+"</label><br>");
				i++;
			}
			
			out.println("<div ><input class='form-control btn-warning' type='submit' id='submit' value='order'></div>");
			out.println("</form>");
			out.println("</div></div>");
			out.println("<div class='col-lg-3'></div>");
			
		}
		else
		{
			out.println("<center><h4>No Saved Address</h4></center>");
		}
		%>
		
		
		
		
		
		<!-- If saved Address are less than 2 user have option to open a from and save address -->
		<div class="container">
		<% 
			if(addreslen<2)
			{
				out.println("<center><a href='#' class='btn btn-info' onclick='openfrom()'>ADD a Address</a></center>");
			}
		%>
		</div>
		<!-- Form to save address -->
		<div class="col-lg-3"></div>
		<div class="form col-lg-6" id="formopen" style="display:none;">
		<form action="address_save.jsp">
			<input type="hidden" class="form-control" value="<% out.println(id);%>" id="id" name="id">
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
			<input type="submit" value="Save Address" class="form-control btn-success" id="submit">
		</div>
		<div class="form-group"><a href="#" class="btn btn-danger" onclick="closeForm()">Close The From</a></div>
		</form>
		
		</div>
		<div class="col-lg-3"></div>
		
	</div>
	
	
	<!-- Address taking at run time -->
	<div id="runAddress" style="display:none;">
	<div class="col-lg-3"></div>
	<div class="col-lg-6">
	<form action="ordersave.jsp" method="get" name="runAddress">
		<div class="form-group">
			
			<input type="hidden" class="form-control"  value="<%out.println(id);%>" id="product_id" name="product_id" readonly>
			<input type="hidden" class="form-control"  value="<%out.println(product);%>" id="product" name="product" readonly>
			<input type="hidden" value=1 class="form-control"  id="quantity" name="quantity" readonly>
		</div>
		
		<div class="form-group">
			
			<input type="hidden" class="form-control"  value="<%out.println(price);%>" id="price" name="price" readonly>
		</div>
		
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
			<input type="submit" value="CheckOut" class="form-control btn-success" id="submit">
		</div>
	</form>
	</div>
	<div class="col-lg-3"></div>
	</div>
	<script src="validate.js"></script>
	
	
	<script>
		function openAddress()
		{
			document.getElementById("savedAddress").style.display="block";
			document.getElementById("runAddress").style.display="none";
		}
		function openNewAddress()
		{
			document.getElementById("savedAddress").style.display="none";
			document.getElementById("runAddress").style.display="block";
		}
		
		function openfrom()
		{
			document.getElementById("formopen").style.display="block";
		}
		function closeForm()
		{
			document.getElementById("formopen").style.display="none";
			console.log("hello");
		}
		function checkbox()
		{
			//console.log("checked");
			var id=0;
			var checkboxcheck1=document.getElementById("address1");
			var checkboxvalue1=document.getElementById("address1").value;
			
			var checkboxcheck2=document.getElementById("address2");
			var checkboxvalue2=document.getElementById("address2").value;
			
			if(checkboxcheck1.checked===true)
				id=checkboxvalue1
			if(checkboxcheck2.checked==true)
				id=checkboxvalue2
			//console.log(document.getElementById('price').value+" "+id);
			
			if(id!=0)
				return true;
			return false;
		}
		function quantityFunc(value)
		{
			//console.log(value);
			document.forms['runAddress']['quantity'].value=value;
			document.forms['defaultsaveForm']['quantity'].value=value;
		}
	</script>
	
</body>
</html>
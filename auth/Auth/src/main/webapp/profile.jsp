<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,java.io.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body onload="sessionValidate()">
	<div class="text-center"><h1>Profile Page</h1></div>
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
				<li class="active"><a href="profile.jsp">My profile</a></li>
				<li id="usersbutton" style="display:none;"><a href="users.jsp">Users</a></li>
				 <li><a href="cart.jsp">Cart  <span class="badge"  id="cartcount">0</span></a></li>
		        <li><a href="" onclick="logout()">Logout</a></li>
		      </ul>
		    </div>
		  </div>
		</nav>
		<!-- Menu bar Ends... -->
	</div>
	<div class="container">
	<br>
	<%
		if(session.getAttribute("updatemsg")!=null && session.getAttribute("updatemsg").equals("true"))
		{
			out.println("<div class='alert alert-success'>Updated Successfully</div>");
			session.setAttribute("updatemsg",null);
		}
		if(session.getAttribute("updatemsg")!=null && session.getAttribute("updatemsg").equals("fail"))
		{
			out.println("<div class='alert alert-danger'>Account already exists with this email</div>");
			session.setAttribute("updatemsg",null);
		}
	%>
	<div class="row">
	<div class="col-lg-6" style="border:1px solid;">
	
	<!-- Profile Starts -->
	

		<div class="text-center text-primary"><h1>Profile</h1></div>
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
		else
			response.sendRedirect("login.html");
		
		email=Encryption.dec(email);
		String query="select * from users where email=?";
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1, email);
		String phone="";
		ResultSet rs=stmt.executeQuery();
		while(rs.next())
		{
			phone=rs.getString(4);
			out.println("<div class='alert alert-default' style='background:#adaba3;'>Name         :     "+rs.getString(2)+"<div style='float:right;'><button onclick='profFunction(this.value)' value='name' data-toggle='modal' data-target='#myModal' class='btn btn-warning'><span class='glyphicon glyphicon-edit'></span></button></div></div>");
			out.println("<div class='alert alert-default' style='background:#adaba3;'>Email        :     "+rs.getString(3)+"<div style='float:right;'><button onclick='profFunction(this.value)' value='email' data-toggle='modal' data-target='#myModal' class='btn btn-warning'><span  class='glyphicon glyphicon-edit'></span></button></div></div>");
			out.println("<div class='alert alert-default' style='background:#adaba3;'>Phone        :     "+rs.getString(4)+"<div style='float:right;'><button onclick='profFunction(this.value)' value='phone' data-toggle='modal' data-target='#myModal' class='btn btn-warning'><span class='glyphicon glyphicon-edit'></span></button></div></div>");
			out.println("<div class='alert alert-default' style='background:#adaba3;'>Password     :     "+rs.getString(5)+"<div style='float:right;'><button onclick='profFunction(this.value)' value='password' data-toggle='modal' data-target='#myModal' class='btn btn-warning'><span class='glyphicon glyphicon-edit'></span></button></div></div>");
		}
		%>
			<!-- Popup modal from bootstrap used to get data from user in popup mode -->
			<div class="modal fade" id="myModal" role="dialog">
		    <div class="modal-dialog modal-sm">
		      <div class="modal-content">
		      <div class="modal-header">
		      	<h5 class="modal-title" style="float:left"><b>Update Form</b></h5>
		      	<button type="button" style="float:right; background:white;" class="btn btn-default btn-sm" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
		      </div>
		        <div class="modal-body">
		        	<form action="updateUserDetails.jsp" name="updateForm" method='post' id="updateForm">
		        	<label id="data">Data</label>
		        	<input type="hidden" name="type" id="type" value="">
		        	<input type="hidden" name="oldemail" value="<% out.println(email);%>">
		        	<input type="hidden" name="phone" value="<% out.println(phone); %>" id="phone">
		        	<input type="text" id="datainput" name="data" class="form-control" required></input>
		        	<button id="sendButton" class="btn btn-success" style="display:none;" onclick="buttondisable()">Verify</button>
		        	<input type="hidden" id="otp" name="otp" class="form-control" placeholder="Enter otp.." required></input>
		            <input type="submit" value="submit" class="form-control btn-warning">
		            </form>
		        </div>
		      </div>
		    </div>
		  </div>
		  <!-- popup mode ends... -->
		  
	</div>
	<!-- profile ends -->
	
	<!-- Address Starts -->
	<div class="col-lg-6" style="border:1px solid;">
		<div class="text-center text-primary"><h1>Address</h1></div>
		<% 
			String addQuery="SELECT * FROM `user_address` WHERE user_id=(SELECT id from users WHERE email=?);";
			PreparedStatement st=con.prepareStatement(addQuery);
			st.setString(1,email);
			ResultSet addres=st.executeQuery();
			while(addres.next())
			{
				out.println("<div class='alert alert-default' style='background:#adaba3;' >"+addres.getString(3)+" "+addres.getString(4)+" "+addres.getString(5)+"<div style='float:right'><button onclick='openAddressForm(this.value)' value='"+addres.getInt(1)+"' class='btn btn-warning'><span class='glyphicon glyphicon-edit'></span></button></div></div>");
			}
		%>
	</div>
	<!-- Address ends -->
	</div>
	<br>
	<br>
	
	<!-- Form to give address Details -->
	</div>
	<div class="container">
	<div class="col-lg-3"></div>
	<div class="col-lg-6" id="updateAddressForm" style="display:none;">
		<form action="updateAddress.jsp" name="updateAddressForm">
			<input type="hidden" class="form-control" value="" id="address_id" name="address_id">
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
	</div>
<script src="validate.js"></script>
<script src="profile.js"></script>
<script>
document.addEventListener('keydown', function(event){
	if(event.key === "Escape"){
		jQuery("#myModal").modal('hide');
		 
	}
});
</script>
</body>
</html>
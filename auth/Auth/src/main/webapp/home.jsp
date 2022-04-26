<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,Backend.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 
 <!--Plugin CSS file with desired skin-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.1/css/ion.rangeSlider.min.css"/>

<!--jQuery-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<!--Plugin JavaScript file-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.1/js/ion.rangeSlider.min.js"></script>   
 
 <script src="validate.js"></script>

<style>
		.word
		{
		   overflow: hidden;
		   text-overflow: ellipsis;
		   display: -webkit-box; 
		   -webkit-line-clamp: 3;
		   -webkit-box-orient: vertical;
		   margin-bottom:10px;
		   height:75px;
		}
		.sold-out-overlay {
			background: #654ea3;
			color: #fff;
			font-size: 14px;
			font-weight: 600;
			padding: 5px 10px;
			position: absolute;
		}
		.new_product {
			background: #f7a6c8;
			color: #fff;
			font-size: 14px;
			font-weight: 600;
			padding: 5px 10px;
			position: absolute;
		}
</style> 

</head>
<body onload="sessionValidate()">	
	<div class="container">
		<div class="text-center text-warning"><h1>Product Page</h1></div>
		
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
		        <li class="active"><a href="home.jsp">Home</a></li>
		        <li id="admin" style="display:none;"><a href="add.jsp">Manage Products</a></li>
		        <li><a href="orderslist.jsp" id="order">My orders</a></li>
		        <li><a href="profile.jsp">My profile</a></li>
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
			if(email!=null)
			{
				email=Encryption.dec(email);
			
			String url = "jdbc:mysql://localhost:3306/javauserdb";
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(url, "root", "");
			String role = "";
			String query = "select * from users where email=?";
			PreparedStatement stmt = con.prepareStatement(query);
			stmt.setString(1, email);
			ResultSet rs = stmt.executeQuery();

			int resultSetSize = 0;
			while (rs.next()) {
				role = rs.getString(6);
				resultSetSize++;
			}
			con.close();
			
			Cookie msg = new Cookie("role", role);
			session.setAttribute("role",role);
			msg.setMaxAge(60*60*12);
			response.addCookie(msg);
			
			}
			
			if(session.getAttribute("orderStatus")!=null && session.getAttribute("orderStatus").equals("true"))
			{
				out.println("<div class='alert alert-success'>Your order was Placed Successfully.To Check your order. GoTo <a href='orderslist.jsp'>My Orders</a></div>");
				session.setAttribute("orderStatus",null);
			}
			if(session.getAttribute("cart")!=null && session.getAttribute("cart").equals("added"))
			{
				out.println("<div class='alert alert-success'>Product added to cart.Go To <a href='cart.jsp'>cart >></a></div>");
				session.setAttribute("cart",null);
			}
			if(session.getAttribute("cart")!=null && session.getAttribute("cart").equals("failed"))
			{
				out.println("<div class='alert alert-danger'>Sorry we don't have that much quantity</a></div>");
				session.setAttribute("cart",null);
			}
			
			if(session.getAttribute("orderStatus")!=null && session.getAttribute("orderStatus").equals("outofstock"))
			{
				out.println("<div class='alert alert-danger'>The product your are trying is Out Of Stock</div>");
				session.setAttribute("orderStatus",null);
			}
		%>
		</div>
	<div class="container">
		<!-- Form to sort the products -->
		<form class="form-inline"  name="filterForm"> 
		
			<div class="form-group">
			<label>Category</label>
			<select id="category" name="category" class="form-control" onchange="runFunc()">
				<option value="0">All</option>
				<option value="1">Men</option>
				<option value="2">Women</option>
				<option value="3">Accessories</option>
			</select>
			</div>
			
			<div class="form-group" style="width:40%; margin:0px 10px;">
			<input type="text" id="rangePrimary" name="rangePrimary" value="" step="100" class="form-control" onchange="runFunc()" />
			</div>
			
			<div class="form-group">
			<label>Sort By</label>
			<select id="sorting" name="sort" class="form-control" onchange="runFunc()">
			<option value="0">All</option>
			  <option id="1" value="1">Price: Low to High</option>
			  <option id="2" value="2">Price: High to Low</option>
			  <option id="3" value="3">Ascending (A-Z)</option>
			  <option id="4" value="4">Descending (z-A)</option>
			  <option id="5" value="5">Recently Added</option>
			</select>
			
			<input type="text" id="search" placeholder="Search.." class="form-control" onkeyup="runFunc()">
			</div>
		</form>
		<!-- ends.. -->
		<br>
	</div>
	
	
	<div class="container">
		
		<div class="row">
		
		
		<div id="result"></div>
		
		
		</div>
	</div>
	
	<script type="text/javascript" src='filter.js'></script>
</body>
</html>
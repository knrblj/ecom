<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.sql.*,java.util.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Orders</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body onload="sessionValidate()">
	<div class="container">
	<h1 class="text-center text-primary">My Orders</h1>
	
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
		        <li class="active"><a href="orderslist.jsp" id="order">My orders</a></li>
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
	<div class='container'>
		<%
		if(session.getAttribute("order")!=null && session.getAttribute("order").equals("cancelled"))
		{
			out.println("<div class='alert alert-success'>Your order was Cancelled</div>");
			session.setAttribute("order",null);
		}
		if(session.getAttribute("order")!=null && session.getAttribute("order").equals("updated"))
		{
			out.println("<div class='alert alert-success'>Your order status was updated</div>");
			session.setAttribute("order",null);
		}
		%>
	</div>
	<div>
	<form class="form-inline" method="post" action="">
		<label for="filter">Filter By order Status</label>
		<select name="filter" id="filter" class="form-control" onchange="filterFunc(this.value)">
			<option value="all">All</option>
			<option value="Ordered">Ordered</option>
			<option value="Processing">Processing</option>
			<option value="Cancelled">Cancelled</option>
			<option value="Delivered">Delivered</option>
		</select>
	</form>
	</div>
	
	<table class="table table-hover text-center">
	<thead>
	<tr>
	<th class="text-center">Order Id</th>
	<th class="text-center">Product Name</th>
	<th class="text-center">Price</th>
	<th class="text-center">Quantity</th>
	<th class="text-center">Name</th>
	<th class="text-center">Phone</th>
	<th class="text-center">Address</th>
	<th class="text-center">Ordered Time</th>
	<th class="text-center">Status</th>
	<th class="text-center">Last Updated At</th>
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
	if(email==null)
		response.sendRedirect("login.html");
	
	email=Encryption.dec(email);
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	
	String filter=request.getParameter("filter");
	if (session.getAttribute("role")==null)
		response.sendRedirect("home.jsp");
	if(session.getAttribute("role")!=null && (session.getAttribute("role").equals("admin") || session.getAttribute("role").equals("root")))
	{
		String query="";
		PreparedStatement stmt=null;
		if(filter==null || filter.equals("all"))
		{	
			query="SELECT orders.id,product_name,product_cost*quantity,name,phone,address,Ordered_time,Order_status,Last_update,quantity \n"+
				"from products,orders where products.id=orders.product_id order by orders.id desc";
			stmt=con.prepareStatement(query);
		}
		else
		{
			query="SELECT orders.id,product_name,product_cost*quantity,name,phone,address,Ordered_time,Order_status,Last_update,quantity \n"+
					"from products,orders where products.id=orders.product_id and Order_status=? order by orders.id desc";
			stmt=con.prepareStatement(query);
			stmt.setString(1, filter);
		}
		
		ResultSet rs=stmt.executeQuery();
		while(rs.next())
		{
			out.println("<tr>");
			out.println("<td>"+ rs.getString(1)  +"</td>");
			out.println("<td>"+ rs.getString(2)  +"</td>");
			out.println("<td>"+ rs.getString(3)  +"</td>");
			out.println("<td>"+ rs.getString(10)  +"</td>");
			out.println("<td>"+ rs.getString(4)  +"</td>");
			out.println("<td>"+ rs.getString(5)  +"</td>");
			out.println("<td>"+ rs.getString(6)  +"</td>");
			out.println("<td>"+ rs.getString(7)  +"</td>");
			out.println("<td>"+ rs.getString(8)  +"</td>");
			out.println("<td>"+ rs.getString(9)  +"</td>");
			out.println("<td>  <button class='btn btn-warning' title='Edit order' id='editid' value='"+rs.getInt(1)+"|split|"+rs.getString(8)+"' onclick='idFunction(this.value)' data-toggle='modal' data-target='#myModal'><span class='glyphicon glyphicon-edit'></span></button></td>");
			out.println("<td><button class='btn btn-success' title='Track Order' value='"+rs.getString(1)+"' onclick='trackFunc(this.value)'><span class='glyphicon glyphicon-send'></span></button></td>");
			out.println("</tr>");
		}
		con.close();
	}
	///for user..
	else
	{
		String query="";
		PreparedStatement stmt=null;
		if(filter==null || filter.equals("all"))
		{
			query="SELECT orders.id,product_name,product_cost*quantity,name,phone,address,Ordered_time,Order_status,Last_update,quantity \n"+
					"from products,orders \n"+
					"where \n"+
					"products.id=orders.product_id \n"+
					"and \n"+
					"orders.user_id=(SELECT id from users where email=?)  order by orders.id desc;";
			stmt=con.prepareStatement(query);
			stmt.setString(1, email);
		}
		else
		{
			query="SELECT orders.id,product_name,product_cost*quantity,name,phone,address,Ordered_time,Order_status,Last_update,quantity \n"+
					"from products,orders \n"+
					"where \n"+
					"products.id=orders.product_id \n"+
					"and \n"+
					"orders.user_id=(SELECT id from users where email=?) and order_status=? order by orders.id desc;";
			stmt=con.prepareStatement(query);
			stmt.setString(1, email);
			stmt.setString(2,filter);
		}
		ResultSet rs=stmt.executeQuery();
		while(rs.next())
		{
			out.println("<tr>");
			out.println("<td>"+ rs.getString(1)  +"</td>");
			out.println("<td>"+ rs.getString(2)  +"</td>");
			out.println("<td>"+ rs.getString(3)  +"</td>");
			out.println("<td>"+ rs.getString(10)  +"</td>");
			out.println("<td>"+ rs.getString(4)  +"</td>");
			out.println("<td>"+ rs.getString(5)  +"</td>");
			out.println("<td>"+ rs.getString(6)  +"</td>");
			out.println("<td>"+ rs.getString(7)  +"</td>");
			out.println("<td>"+ rs.getString(8)  +"</td>");
			out.println("<td>"+ rs.getString(9)  +"</td>");
			if(rs.getString(8).equals("Ordered"))
			{
				//out.println("<form action='cancel.jsp' method='post'>");
				//out.println("<input type='hidden' name='order_id' value="+rs.getString(1)+">");
				out.println("<td><button class='btn btn-danger'  onclick='userCancel(this.value)' data-toggle='modal' data-target='#userModal' value="+rs.getString(1)+">Cancel</span></button></td>");
			}else
			{
				out.println("<td><button class='btn btn-default'  title='unable to cancel the product when it is "+rs.getString(8)+"' disabled>Cancel</span></button></td>");
			}
			out.println("<td><button class='btn btn-success' title='Track Order' value='"+rs.getString(1)+"' onclick='trackFunc(this.value)'><span class='glyphicon glyphicon-send'></span></button></td>");
			out.println("</tr>");
		}
		con.close();
	}
	%>
	</table>
	<!-- popup status change form   for admin-->
	<div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
      <div class="modal-header">
		      	<h5 class="modal-title" style="float:left"><b>Order Status</b></h5>
		      	<button type="button" style="float:right; background:white;" class="btn btn-default btn-sm" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
		      </div>
        <div class="modal-body">
        	<form action="updateOrder.jsp" name="updateForm">
        	<input type="hidden" id="id" name="id" value="" class="form-control"></input>
            <select id="status" name="status" class="form-control">
            	<option value="Ordered">Ordered</value>
                <option value="Processing">Processing</value>
                <option value="Cancelled">Cancelled</value>
                <option value="Delivered">Delivered</value>
            </select><br>
            <input type="submit" value="submit" class="form-control btn-warning">
            </form>
        </div>
      </div>
    </div>
  </div>
	</div>
	<!-- Ends.. -->
	
	<!-- Popup for user to get cancellation reason -->
	<div class="modal fade" id="userModal" role="dialog">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
      <div class="modal-header">
		      	<h5 class="modal-title" style="float:left"><b>Order Status</b></h5>
		      	<button type="button" style="float:right; background:white;" class="btn btn-default btn-sm" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
		      </div>
        <div class="modal-body">
        	<form action="cancel.jsp" name="userCancelForm" method="post">
        	<input type="hidden" id="id" name="id" value="" class="form-control">
        	
        	<div class="form-group">
        	<input type="radio" id="1" name='reason' value="Change Address">
        	<label>I want to change address</label><br>
        	
        	<input type="radio" id="1" name='reason' value="Changed My Mind">
        	<label>I Have Changed My Mind</label><br>
        	
        	<input type="radio" id="1" name='reason' value="Price is High">
        	<label>Price of the Product is too high</label><br>
        	
        	<input type="radio" id="1" name='reason' value="Delivery Date is long">
        	<label>Delivery time is very long</label><br>
        	
        	<input type="radio" id="1" name='reason' value="Purchased somewhere">
        	<label>Purchased the product somewhere</label>
        	</div>
            <input type="submit" value="submit" class="form-control btn-warning">
            </form>
        </div>
      </div>
    </div>
  </div>
	</div>
<script src="validate.js"></script>
<script>
	//document.getElementById('option').innerHTML=window.location.href.split("=")[1];
	
	
	const $select = document.querySelector('#filter');
	if(window.location.href.split("=")[1]==null)
		$select.value = 'all';
	else
		$select.value = window.location.href.split("=")[1];
	
	function trackFunc(value)
	{
		window.location.href="track.jsp?id="+value;
	}
	
	function idFunction(value)
	{
		var status=value.split("|split|")[1];
		console.log(status);
		
		const $select = document.querySelector('#status');
		$select.value=status;
		
		var id=value.split("|split|")[0];
		document.forms['updateForm']['id'].value=id;
	}
	
	function userCancel(value)
	{
		//console.log(value);
		document.forms['userCancelForm']['id'].value=value;
	}
	function filterFunc(value)
	{
		window.location.href="orderslist.jsp?filter="+value;
	}
	
	document.addEventListener('keydown', function(event){
		if(event.key === "Escape"){
			jQuery("#myModal").modal('hide');
			jQuery("#userModal").modal('hide');
			 
		}
	});
</script>
</body>
</html>
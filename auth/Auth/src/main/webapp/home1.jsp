<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
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

<title>home</title>
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
			String sort=request.getParameter("sort");
			String category=request.getParameter("category");
			String priceRange=request.getParameter("rangePrimary");
			if(priceRange==null)
				priceRange="0;1000";
			int min=Integer.parseInt(priceRange.split(";")[0]);
			int max=Integer.parseInt(priceRange.split(";")[1]);
			if(category==null)
				category="0";
			if(sort==null)
				sort="0";
			
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
		
		
		<!-- Form to sort the products -->
		<form class="form-inline" action="home.jsp" method="post" name="filterForm"> 
		
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
			<input type="submit" id="submit" value="Apply" class="form-control btn btn-primary">
			</div>
		</form>
		<!-- ends.. -->
		<% 
		try
		{
			String query="select *,hour(TIMEDIFF(CURRENT_TIMESTAMP,time)) as td from products where status_of_product='0' and product_cost>=? and product_cost<=? ";
			
			//sorting the category
			if(category.equals("1"))
				query+="and (category like 'Men' OR category like '%|men%' OR category like 'men|%') ";
			else if(category.equals("2"))
				query+="and category like BINARY '%women%' ";
			else if(category.equals("3"))
				query+="and category like BINARY '%accessories%' ";
			
			///sorting the products by order
			if(sort.equals("1"))
			{
				query+="order by product_cost ";
			}
			else if(sort.equals("2"))
			{
				query+="order by product_cost desc";
			}
			else if(sort.equals("3"))
			{
				query+="order by product_name";
			}
			else if(sort.equals("4"))
			{
				query+="order by product_name desc";
			}
			else if(sort.equals("5"))
			{
				query+="order by time";
			}
			
			
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setInt(1,min);
			stmt.setInt(2,max);
			//out.println(min+" "+max);
			ResultSet rs=stmt.executeQuery();
			//out.println("<div class='text-center text-primary'><h2>Old Products</h2><p>Added more than 24 hours ago</p></div>");
			out.println("<div class='row' style='margin-top:10px;'>");
			while(rs.next())
			{
				//out.println(min+" "+max);
				out.println("<div class='col-lg-4' style='border:1px solid;'>");
				out.print("<br>");
				out.println("<div>");
				if(rs.getInt(10)<24 && rs.getInt(7) >0)  //new label for product added before 24 hors
				{
					out.println("<span class='new_product'>New</span>");
				}
				if(rs.getInt(7)<=5 && rs.getInt(7)>0) //only few left label for stock less than 5
				{
					out.println("<span style='float:right; font-size:12px;' class='label label-danger'>Only Few Left</span>");
				}
				if(rs.getInt(7)==0) //Comming soon label for stock is zero
				{
					out.println("<span style='float:right; font-size:12px;' class='label label-danger'>Comming Soon</span>");
				}
				out.println("<div style='width:100px; height:100px'><img class='rounded img-responsive center-block'  height='100' width='100'  src="+rs.getString(5)+"></div>");
				out.println("</div>");
				out.println("<div class='text-center'><h1>"+rs.getString(2));
				out.println("</h1></div>");
				out.println("<h4> <b>RS. "+rs.getString(4)+" /- only</b></h4>");
				out.println("<div class='word'>"+rs.getString(3)+"</div>");
				out.println("<div style='height:75px;'>");
				if(rs.getInt(7)!=0)
				{
				out.println("<form  method='post' onsubmit='return updateCart()' action='Cart'>");
				out.println("<label for=quantity>Quantity</label><input type=number id=quantity name=quantity min=1 max=10 value='1' required><br>");
				out.println("<input type=hidden value='"+rs.getString(1)+"' id=product_id name=product_id></input>");
				out.println("<div style='float:left'><button class='btn btn-success'>Add to Cart</button></div>");
				out.println("</form>");
				out.println("<div style='float:right'><a class='btn btn-success' href='order.jsp?id="+rs.getString(1)+"'>Buy Now</a></div>");
				}
				else
				{
					out.println("<br>");
					out.println("<span class='sold-out-overlay'>Sold Out </span>");
				}
				out.println("</div></div>");
			}
			out.println("</div>");
			con.close();
		}
		catch(Exception e)
		{
			out.println(e);
		}
		
		out.println("<script>");
		out.println("document.querySelector('#sorting').value="+sort);
		out.println("document.querySelector('#category').value="+category);
		out.println("$('#rangePrimary').ionRangeSlider({ type: 'double', grid: true, min: 0, max: 1000, step: 50,from:"+min+",to:"+max+",prefix: 'RS'});");
		out.println("</script>");
		%>
		
		<script type="text/javascript">
			function runFunc()
			{
				document.getElementById('submit').click();
			}
		</script>
	</div>
</body>
</html>
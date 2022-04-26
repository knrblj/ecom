<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add a product</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
		.word
		{
		   overflow: hidden;
		   text-overflow: ellipsis;
		   -webkit-line-clamp: 1; 
		           line-clamp: 1; 
		   -webkit-box-orient: vertical;
		   width:500px;
		   height:50px;
		}
</style>
</head>
<body onload="sessionValidate()">
	<div class="text-center"><h1>Add Product</h1></div>
	
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
		        <li class="active" id="admin" style="display:none;"><a href="add.jsp">Manage Products</a></li>
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
			email=Encryption.dec(email);
			if(session.getAttribute("role").equals("user") || session.getAttribute("role")==null)
			{
				response.sendRedirect("home.jsp");
			}
			if(session.getAttribute("admsg")!=null)
			{
				if(session.getAttribute("admsg").equals("delete"))
				{
					out.println("<div class='alert alert-success'>Product deleted Successfully</div>");
				}
				if(session.getAttribute("admsg").equals("deleteerror"))
				{
					out.println("<div class='alert alert-danger'>Product can't be deleted, because it have some orders.</div>");
				}
				if(session.getAttribute("admsg").equals("add"))
				{
					out.println("<div class='alert alert-success'>Product Added Successfully...</div>");
				}
				if(session.getAttribute("admsg").equals("update"))
				{
					out.println("<div class='alert alert-success'>Product Updated Successfully...</div>");
				}
				session.setAttribute("admsg", null);
			}
		%>
		<input type="text" name="search" class="form-control" placeholder="search a product by name..." id="search" onkeyup="searchFunc()">
		<table class="table table-hover text-center">
			<thead>
			<tr>
			<th>Image</th>
			<th data-colname="id" data-order="asc">Product Id &#9660</th>
			<th data-colname="product" data-order="asc">Name &#9660</th>
			<th data-colname="stock" data-order="asc">Quantity &#9660</th>
			<th data-colname="cost" data-order="asc">Price &#9660</th>
			<th data-colname="status" data-order="asc">Status &#9660</th>
			<th>Description</th>
			<th >Edit</th>
			<th >Delete</th>
			</tr>
			</thead>
			<tbody id="result"></tbody>
		</table>
	</div>
	
	<div class="container"><hr><center><a class="btn btn-success" onclick="openProductForm()">Add a Product</a></center></div>
	
	<!-- Form to add product details -->
	<div class="col-lg-3"></div>
	<div class="col-lg-6" style="display:none;" id="productForm">
	<form action="UploadFile" method="POST" enctype = "multipart/form-data">
		<div class="form-group">
			<label for="name">Product Name</label>
			<input type="text"  name="name" class="form-control" placeholder="Product name (* Required field)" required>
		</div>
		
		<div class="form-group">
			<label for="price">Product price</label>
			<input type="number" name="price" class="form-control" placeholder="Product price (* Required field)" required >
		</div>
		
		<div class="form-group">
			<label for="description">Product Description</label>
			<textarea class="form-control" name="description"  rows="4" required></textarea>
		</div>
		
		<div class="form-group">
			<label for="Qunatity">Product Qunatity</label>
			<input type="number" name="quantity" class="form-control" placeholder="Product quantity (* Required field)" required>
		</div>
		
		<div class="form-group">
				<label for="image">Product Image</label>
				<input type="file" accept="image/*" name="image" id="image" class="form-control" placeholder="Product image url (* Required field)" required>
		</div>
		
		<div class="form-group">
			<input type="submit" value="ADD PRODUCT" class="form-control btn-success">
		</div>
		<div class="form-group"><a href="#" class="btn btn-danger" onclick="closeForm()">Close The From</a></div>
	</form>
	</div>
	<div class="col-lg-3"></div>
	<!-- End of the form -->
	
	
	
	<!-- 
	
	
	
	
	 -->
	

	
	<!-- Form to update details -->
	<!-- Popup modal from bootstrap used to get data from user in popup mode -->
			<div class="modal fade" id="myModal" role="dialog">
		    <div class="modal-dialog modal-sm">
		      <div class="modal-content">
		      <div class="modal-header">
		      	<h5 class="modal-title" style="float:left"><b>Update Form</b></h5>
		      	<button type="button" style="float:right; background:white;" class="btn btn-default btn-sm" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
		      </div>
		        <div class="modal-body">
		        	<form action="UploadFile" method="POST" name="updateProduct" enctype = "multipart/form-data">
		        	<div class="form-group">
						<label for="name">Product Name</label>
						<input type="hidden" id="id" name="id" class="form-control" required >
						<input type="text" id="name" name="name" class="form-control" placeholder="Product name (* Required field)" required >
					</div>
					
					<div class="form-group">
						<label for="price">Product price</label>
						<input type="number" id="price" name="price" class="form-control" placeholder="Product price (* Required field)" required>
					</div>
					
					<div class="form-group">
						<label for="description">Product Description</label>
						<textarea class="form-control" id="description" name="description"  rows="4" required></textarea>
					</div>
				
					<div class="form-group">
						<label for="Qunatity">Product Qunatity</label>
						<input type="number" name="quantity" id="quantity" class="form-control" placeholder="Product quantity (* Required field)" required>
					</div>
					
					<div class="form-group">
						<label for="Qunatity">Product Status</label>
						<select name="selection" id="selection" class="form-control">
							<option value="0">Show</option>
							<option value="1">Hide</option>
						</select>
					</div>
					
					<div class="form-group">
							<label for="image">Product Image</label>
							<input type="file" accept="image/*" name="image" id="image" class="form-control" placeholder="Product image url (* Required field)">
					</div>
					
					<div class="form-group">
						<input type="submit" value="Update PRODUCT" class="form-control btn-success">
					</div>
		            </form>
		        </div>
		        <!--  div class="modal-footer">
		          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		        </div> -->
		      </div>
		    </div>
		  </div>
		  <!-- popup mode ends... -->
	
	<script src="validate.js"></script>
	<script type="text/javascript">
		function openProductForm()
		{
			document.getElementById('productForm').style.display="block";
		}
		function closeForm()
		{
			document.getElementById('productForm').style.display="none";
		}
		//set the values
		function editForm(value)
		{
			var productarr=value.split("|split|");
			//console.log(productarr);
			//console.log(productarr);
			document.forms['updateProduct']['id'].value=productarr[0];
			document.forms['updateProduct']['name'].value=productarr[1];
			document.forms['updateProduct']['price'].value=productarr[2];
			document.forms['updateProduct']['description'].value=productarr[3];
			//document.forms['updateProduct']['image'].value=productarr[4];
			document.forms['updateProduct']['quantity'].value=productarr[5];
		}
		
		///function to change the status of show and hide of the product
		function showHideFunc(value)
		{
			console.log(value);
			var xhttp=new XMLHttpRequest();
			var url="ShowHide"
			xhttp.open("POST",url,true);
			xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			xhttp.send("id="+value);
			xhttp.onreadystatechange = function ()
			{
				if(this.readyState=4 && this.status==200)
				{
					if(this.responseText=='success')
						window.location.href="add.jsp";
				}
			}
		}
		
		//click on escape to close the form
		document.addEventListener('keydown', function(event){
			if(event.key === "Escape"){
				jQuery("#myModal").modal('hide');
				 
			}
		});
	</script>
<script type="text/javascript" src="adminadd.js"></script>
</body>
</html>
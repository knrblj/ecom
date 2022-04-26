<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 <script src="validate.js"></script>
 <script src="logvalidate.js"></script>
</head>
<body onload="checkCookie()">   <!-- Checkcookie will check any email not found cookie -->
	<div class="container">
	<div class="text-success text-center"><h1>Registration form</h1>
	</div>
		<%
			if(session.getAttribute("email")!=null && session.getAttribute("email").equals("not_valid"))
		    {
			  	out.println("<div class='container alert alert-danger'>Not a valid Email</div>");
				session.setAttribute("email",null);
			}
		%>
		
		<div class="col-lg-3"></div>
		<div class="col-lg-6">
		
		<!-- form to collect data from user and pass through register servlet -->
		
		<form  action="Register" class="form-group" method="post">
			<div id="cookiestatus"></div>
			<div class="form-group">
			<label for="name">Name</label>
			<input type="text" class="form-control" name="name" id="name" placeholder="Enter your name..">
			<div id="nameres"></div>
			</div>
			
			<div class="form-group">
			<label for="email">Email Address</label>
			<input type="email" class="form-control" name="email" id="email" placeholder="Enter your Email Address" onChange="return check_user(this.value);">
			<div id="emailres"></div>
			</div>
			
			<div class="form-group">
			<label for="phone">Phone Number</label>
			<input type="number" class="form-control" name="phone" id="phone" placeholder="Enter your Phone Number" value="1234567890">
			<div id="phoneres"></div>
			</div>
			
			<div class="form-group">
			<label for="password">Password</label>
			<input type="password" class="form-control" name="password" id="password" placeholder="Enter password." value="balajik">
			<div id="passwordres"></div>
			</div>
			
			<div class="form-group">
			<label for="cpassword">Confrim Password</label>
			<input type="password" class="form-control" name="cpassword" id="cpassword" placeholder="Confrim password" value="balajik">
			<div id="cpasswordres"></div>
			</div>
			
			<div class="form-group">
			<input type="submit" class="form-control btn-success" value="Register" id="submit" onclick="return validate();">
			</div>
			
			<div>
				<a href="login.html" class="btn btn-warning">Already a user</a>
			</div>
		</form>
		</div>
		<div class="col-lg-3"></div>
	</div>
</body>
</html>
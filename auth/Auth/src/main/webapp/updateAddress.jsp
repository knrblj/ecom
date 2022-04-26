<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Address</title>
</head>
<body onload="sessionValidate()">
	<% 
	String address_id=request.getParameter("address_id"); //using
	String name=request.getParameter("name"); //passing 
	String phone=request.getParameter("phone"); //passing
	String house=request.getParameter("house");
	String state=request.getParameter("state");
	String pincode=request.getParameter("pincode");
	String city=request.getParameter("city");
	
	String address=house+","+city+","+state+","+pincode; //passing
	
	String query="update user_address set name=?,phone=?,address=? where address_id=?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1,name);
	stmt.setString(2,phone);
	stmt.setString(3,address);
	stmt.setString(4,address_id);
	
	int i=stmt.executeUpdate();
	if(i>0)
	{
		session.setAttribute("updatemsg","true");
		response.sendRedirect("profile.jsp");
	}
	else
	{
		out.println("Updating failed");
	}
	
	%>
<script src="validate.js"></script>
</body>
</html>
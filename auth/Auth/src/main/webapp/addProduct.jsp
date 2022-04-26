<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body onload="sessionValidate()">
	<%
	String name=request.getParameter("name");
	String price=request.getParameter("price");
	String description=request.getParameter("description");
	String image=request.getParameter("image");
	
	
	out.print(name+" "+price+" "+" "+description+" "+image);
	
	
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	String query="INSERT INTO products(product_name, product_description, product_cost,product_image) values(?,?,?,?)";
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1, name);
	stmt.setString(2, description);
	stmt.setString(3, price);
	stmt.setString(4, image);
	
	int i=stmt.executeUpdate();
	con.close();
	if(i>0)
	{
		session.setAttribute("admsg","add");
		response.sendRedirect("add.jsp");
	}
	else
	{
		out.println("failed to add a product");
	}
	%>
	<script src="validate.js"></script>
</body>
</html>
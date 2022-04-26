<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	String id=request.getParameter("id");
	String name=request.getParameter("name");
	String price=request.getParameter("price");
	String description=request.getParameter("description");
	String image=request.getParameter("image");
	
	String query="update products set product_name=?,product_cost=?,product_description=?,product_image=? where id=?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1, name);
	stmt.setString(2, price);
	stmt.setString(3, description);
	stmt.setString(4, image);
	stmt.setString(5,id);
	int i=stmt.executeUpdate();
	if(i>0)
	{
		session.setAttribute("admsg","update");
		response.sendRedirect("add.jsp");
	}
	else
	{
		out.print("failed");
	}
	%>
</body>
</html>
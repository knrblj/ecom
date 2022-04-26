<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	String id=request.getParameter("id");
	String email=request.getParameter("email");
	
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
	String query="delete from cart where user_id=(select id from users where email=?) and product_id=?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1, email);
	stmt.setString(2,id);
	int i=stmt.executeUpdate();
	con.close();
	if(i>0)
	{
		session.setAttribute("cart","delete");
		response.sendRedirect("cart.jsp");
	}
	%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body onload="sessionValidate()">
	<%
		String id=request.getParameter("id");
		String query="delete from products where id=?";
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			PreparedStatement st=con.prepareStatement(query);
			st.setString(1, id);
			int i=st.executeUpdate();
			con.close();
			if(i>0)
			{
				session.setAttribute("admsg","delete");
				response.sendRedirect("add.jsp");
			}
			else
			{
				out.println("failed");
			}
		}
		catch(Exception e)
		{
			session.setAttribute("admsg","deleteerror");
			response.sendRedirect("add.jsp");
		}
	%>
<script src="validate.js"></script>
</body>
</html>
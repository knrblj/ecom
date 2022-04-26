<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body onload="sessionValidate()">
	<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	String id=request.getParameter("id");
	String status=request.getParameter("status");
	String email=null;
	String query1="SELECT email FROM users where id=(SELECT user_id from orders WHERE id=?);";
	PreparedStatement st=con.prepareStatement(query1);
	st.setString(1,id);
	ResultSet rs=st.executeQuery();
	while(rs.next())
		email=rs.getString(1);
	
	if(email==null)
		response.sendRedirect("home.jsp");
	
	String query="update orders set order_status=? where id=?";   //updating the db with new order status
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1,status);
	stmt.setInt(2,Integer.valueOf(id));
	
	int i=stmt.executeUpdate();
	con.close();
	if(i>0)
	{
		StatusMail.mailSending(email, id, status);
		session.setAttribute("order","updated");
		response.sendRedirect("orderslist.jsp");
	}
	else 
		out.println("Something went wrong");
	%>
<script src="validate.js"></script>
</body>
</html>
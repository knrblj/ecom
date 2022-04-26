<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String order_id=request.getParameter("id");
		String reason=request.getParameter("reason");
		//out.println(order_id+" "+reason);
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		
		
		String email=null;
		String query1="SELECT email FROM users where id=(SELECT user_id from orders WHERE id=?);";
		PreparedStatement st=con.prepareStatement(query1);
		st.setString(1,order_id);
		ResultSet rs=st.executeQuery();
		while(rs.next())
			email=rs.getString(1);
		
		if(email==null)
			response.sendRedirect("home.jsp");
		
		
		String query="update orders set order_status='cancelled',message=? where id=?";
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1,reason);
		stmt.setString(2,order_id);
		int i=stmt.executeUpdate();
		if(i>0)
		{
			boolean status=StatusMail.mailSending(email, order_id, "Cancelled");
			if(status)
			{
				session.setAttribute("order","cancelled");
				response.sendRedirect("orderslist.jsp");
			}
		}
	%>
</body>
</html>
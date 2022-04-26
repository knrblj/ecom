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
	//session.setAttribute("otp",null);
	//email collecting from the cookies
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
	else
		response.sendRedirect("login.html");
	// ends.. if cookie is empty it will redirect to backwards
	email=Encryption.dec(email);
	String data=request.getParameter("data");
	String type=request.getParameter("type");
	String query="";
	if(type.equals("name"))
		query="update users set name=? where email=?";
	else if(type.equals("phone"))
		query="update users set phone=? where email=?";
	else if(type.equals("password"))
		query="update users set password=? where email=?";
	else if(type.equals("email"))
	{
		Random rnd = new Random();
	    int number = rnd.nextInt(999999);
	   	OtpSend otp=new OtpSend();
	    otp.mailSending(data, number);
	    session.setAttribute("otp",number);
	    out.println(number);
	}
	%>
	<form action='tester.jsp' method='post'>
		<input type='hidden' id='email' name='email' value="<%out.println(data); %>" required>
		<input type='hidden' id='oldemail' name='oldemail' value="<%out.println(email); %>" required>
		<input type='number' id='otp' name='otp' required>
		<input type='submit' value='submit'>
	</form>
	<% 
	///it will create a update query as per our requirement
	//database connection
	if(query.length()>1)
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1,data);
		stmt.setString(2,email);
		
		int i=stmt.executeUpdate();
		con.close();
		if(i>0)
		{
			session.setAttribute("updatemsg", "true");
			response.sendRedirect("profile.jsp");
		}
		else
		{
			out.println("Failed");
		}
	}
	%>
<script src="validate.js"></script>
</body>
</html>
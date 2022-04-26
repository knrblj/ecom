<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,java.io.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Address Save</title>
</head>
<body onload="sessionValidate()">
	<%
	String id=request.getParameter("id");
	String name=request.getParameter("name");
	String phone=request.getParameter("phone");
	String house=request.getParameter("house");
	String state=request.getParameter("state");
	String pincode=request.getParameter("pincode");
	String city=request.getParameter("city");
	String address=house+","+city+","+state+","+pincode;
	int user_id=0;
	
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
	
	if(email==null)
		response.sendRedirect("home.jsp");  //If user tries to open direct this page it will revert back to home page..
	//out.println("order.jsp?id="+id);
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	String query="select id from users where email=?";
	PreparedStatement stmt=con.prepareStatement(query);
	stmt.setString(1, email);
	ResultSet rs=stmt.executeQuery();
	while(rs.next())
		user_id=rs.getInt(1);
	
	String insertQuery="Insert into user_address(user_id,name,phone,address) values(?,?,?,?);";
	PreparedStatement st=con.prepareStatement(insertQuery);
	st.setString(1,String.valueOf(user_id));
	st.setString(2,name);
	st.setString(3,phone);
	st.setString(4,address);
	
	int i=st.executeUpdate();
	con.close();
	if(i>0)
	{
		session.setAttribute("address","saved");
		response.sendRedirect("order.jsp?id="+id);
	}
	else
		out.println("Something went wrong"); 
	%>
	<script src="validate.js"></script>
</body>
</html>
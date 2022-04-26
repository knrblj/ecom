<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Save order</title>
</head>
<body onload="sessionValidate()">
	<%
	String product_id=request.getParameter("product_id");
	String product=request.getParameter("product");
	String price=request.getParameter("price");
	String user_id=request.getParameter("user_id");
	String address_id=request.getParameter("address");
	String quantity=request.getParameter("quantity");
	out.println(product+" "+price+" "+product_id+" "+user_id+" "+address_id);
	
	
	String name="";
	String phone="";
	String address="";
	
	String query="SELECT name,phone,address from user_address where address_id=? and user_id=?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
	PreparedStatement stmt=con.prepareStatement(query);

	stmt.setString(1,address_id);
	stmt.setString(2, user_id);
	ResultSet rs=stmt.executeQuery();
	while(rs.next()) 
	{
		name=rs.getString(1);
		phone=rs.getString(2);
		address=rs.getString(3);
	}
	con.close();
	String house=null;
	String state=null;
	String pincode=null;
	String city=null;
	
	String addarr[]=address.split(",");
	house=addarr[0];
	state=addarr[2];
	city=addarr[1];
	pincode=addarr[3];
	
	response.sendRedirect("ordersave.jsp?product_id="+product_id+"&name="+name+"&phone="+phone+"&house="+house+"&state="+state+"&city="+city+"&pincode="+pincode+"&product="+product+"&price="+price+"&quantity="+quantity);
	%>
	<script type="text/javascript" src="validate.js"></script>
</body>
</html>
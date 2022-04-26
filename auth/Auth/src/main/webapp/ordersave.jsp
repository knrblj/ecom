<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,Backend.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Ordered</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body onload="sessionValidate()">
	<%
	String product_id=request.getParameter("product_id").trim();
	String product=request.getParameter("product");
	String quantity=request.getParameter("quantity");
	String price=request.getParameter("price");
	String name=request.getParameter("name");
	String phone=request.getParameter("phone");
	String house=request.getParameter("house");
	String state=request.getParameter("state");
	String pincode=request.getParameter("pincode");
	String city=request.getParameter("city");
	//out.println(product+" "+price+" "+name+" "+phone+" "+house+" "+pincode+" "+city);
	
	if(quantity==null)
		quantity="1";
	String address=house+","+city+","+state+","+pincode;
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
	
		
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
		
		///getting the id of the user by using email
		String idQuery="select id from users where email=?";
		PreparedStatement st=con.prepareStatement(idQuery);
		int id=0;
		st.setString(1,email);
		ResultSet rs=st.executeQuery();
		while(rs.next())
			id=rs.getInt(1);
		if(id==0)
			response.sendRedirect("login.html");
		
		//Checking qunatity..
		QunatityCheckNUpdate qcu=new QunatityCheckNUpdate();
		if(qcu.qunatityCheck(Integer.parseInt(product_id)) >= Integer.parseInt(quantity))
		{
			//saving the order...
			String query="Insert into orders(user_id,product_id,quantity,name,phone,address) values(?,?,?,?,?,?)";
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setInt(1,id);
			stmt.setString(2,product_id);
			stmt.setString(3,quantity);
			stmt.setString(4,name);
			stmt.setString(5,phone);
			stmt.setString(6,address);
			int i=stmt.executeUpdate();
			con.close();
			if(i>0)
			{
				MailSend mail=new MailSend();
				mail.mailSending(product,price,quantity,email,address,name,phone);
				qcu.quantityUpdate(Integer.parseInt(product_id), Integer.parseInt(quantity));
				session.setAttribute("orderStatus","true");
				response.sendRedirect("home.jsp");
			}
			else
			{
				out.print("fail");
			}
		}
		else
		{
			session.setAttribute("orderStatus","outofstock");
			response.sendRedirect("home.jsp");
		}
	}
	catch(Exception e)
	{
		out.println(e);
	}
	
	%>
	<script src="validate.js"></script>
</body>
</html>
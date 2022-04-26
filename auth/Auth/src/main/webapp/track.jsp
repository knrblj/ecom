<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*,java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Track your order</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">
<link rel="stylesheet" href="style.css">
</head>
<body>
	<div class="container">
		<div class="text-center text-primary"><h1>Track Order</h1></div>
	</div>
	<%
		String id=request.getParameter("id");
		//response.sendRedirect("home.jsp");
		String order_id="0";
		String order_date=null;
		String address=null;
		String status=null;
		String last_update=null;
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");  //creating connection
		String query="select * from orders where id=?";
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1,id);
		ResultSet rs=stmt.executeQuery();
		while(rs.next())
		{
			order_id=rs.getString(1);
			order_date=rs.getString(8);
			address=rs.getString(7);
			status=rs.getString(9);
			last_update=rs.getString(10);
		}
		con.close();
	
	%>
	<div class="container">
    <article class="card">
        <header class="card-header">Tracking </header>
        <div class="card-body">
            <h6>Order ID: <%out.println(order_id); %></h6>
            <article class="card">
                <div class="card-body row">
                    <div class="col"> <strong>Ordered Date</strong> <br><%out.println(order_date); %></div>
                    <div class="col"> <strong>Shipping Address</strong> <br> <%out.println(address); %> </div>
                    <div class="col"> <strong>Status:</strong> <br> <%out.println(status); %> </div>
                    <div class="col"> <strong>Last Update At</strong> <br><%out.println(last_update); %>  </div>
                </div>
            </article>
            <div class="track">
                <div class="step" id="1"> <span class="icon"> <i class="fa fa-check"></i> </span> <span class="text">Ordered</span> </div>
                <%
                if(order_id.equals("0") && status==null)
                	response.sendRedirect("add.jsp");
                if(status!=null && status.equals("Cancelled"))
                {
                	out.println("<div class='step' id='5'> <span class='icon'> <i class='fa fa-check'></i> </span> <span class='text'>Cancelled</span> </div");
                }
                else
                {
                	out.println("<div class='step' id='2'> <span class='icon'> <i class='fa fa-user'></i> </span> <span class='text'> Processing</span> </div>");
                	out.println("<div class='step' id='3'> <span class='icon'> <i class='fa fa-truck'></i> </span> <span class='text'> Shipping  </span> </div>");
                	out.println("<div class='step' id='4'> <span class='icon'> <i class='fa fa-box'></i> </span> <span class='text'> Delivered</span> </div>");
                }
                %>
                
                
            </div>
            <hr>
        </div>
    </article>
    
    <%
    	out.println("<script>");
    	if(status!=null && status.equals("Ordered"))
    	{
    		out.println("document.getElementById('1').classList.add('active');");
    	}
    	else if(status!=null && status.equals("Processing"))
    	{
    		out.println("document.getElementById('1').classList.add('active');");
    		out.println("document.getElementById('2').classList.add('active');");
    	}
    	else if(status!=null && status.equals("Shipping"))
    	{
    		out.println("document.getElementById('1').classList.add('active');");
    		out.println("document.getElementById('2').classList.add('active');");
    		out.println("document.getElementById('3').classList.add('active');");
    	}
    	else if(status!=null && status.equals("Delivered"))
    	{
    		out.println("document.getElementById('1').classList.add('active');");
    		out.println("document.getElementById('2').classList.add('active');");
    		out.println("document.getElementById('3').classList.add('active');");
    		out.println("document.getElementById('4').classList.add('active');");
    	}
    	else if(status!=null && status.equals("Cancelled"))
    	{
    		out.println("document.getElementById('1').classList.add('active');");
    		out.println("document.getElementById('5').classList.add('active');");
    	}
    	out.println("</script>");
    	
    %>
    <hr> <a href="orderslist.jsp" class="btn btn-warning" data-abc="true"> <i class="fa fa-chevron-left"></i> Back to orders</a>
</div>
</body>
</html>
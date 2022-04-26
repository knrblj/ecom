<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users page</title>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 <script src="validate.js"></script>
</head>
<body onload="sessionValidate();">
	<%
		if(session.getAttribute("role")==null || session.getAttribute("role").equals("admin") || session.getAttribute("role").equals("user") )
		{
			response.sendRedirect("home.jsp");
		}
		if(session.getAttribute("roleup")!=null && session.getAttribute("roleup").equals("success"))
		{
			out.print("<div class='container alert alert-success'>Role Updated</div>");
			session.setAttribute("roleup", null);
		}
		//out.print(session.getAttribute("role"));
	%>
	<div class="container">
		<div class='text-center'><h1>Users</h1></div>
		<!-- Menu bar Starts -->
		<nav class="navbar navbar-inverse">
		  <div class="container-fluid">
		    <div class="navbar-header">
		      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span> 
		        <span class="icon-bar"></span>
		      </button>
		      <a class="navbar-brand" href="home.jsp">ECOM WEB</a>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		      <ul class="nav navbar-nav" style="float: right;">
		        <li><a href="home.jsp">Home</a></li>
		        <li id="admin" style="display:none;"><a href="add.jsp">Manage Products</a></li>
		        <li><a href="orderslist.jsp" id="order">My orders</a></li>
		        <li><a href="profile.jsp">My profile</a></li>
		        <li id="usersbutton" style="display:none;" class="active"><a href="users.jsp">Users</a></li>
		        <li><a href="cart.jsp">Cart  <span class="badge"  id="cartcount">0</span></a></li>
		        <li><a href="" onclick="logout()">Logout</a></li>
		      </ul>
		    </div>
		  </div>
		</nav>
		<!-- Menu bar Ends... -->
		<div>
			<table class="table table-hover">
				<thead>
					<tr>
						<th>User_id</th>
						<th>Email</th>
						<th>Name</th>
						<th>Role</th>
						<th>Edit</th>
					</tr>
				</thead>
				<tbody>
					<%
					String url = "jdbc:mysql://localhost:3306/javauserdb";
					Class.forName("com.mysql.cj.jdbc.Driver");
					Connection con = DriverManager.getConnection(url, "root", "");
					String query = "select * from users";
					PreparedStatement stmt = con.prepareStatement(query);
					ResultSet rs = stmt.executeQuery();
					while(rs.next())
					{
						out.println("<tr>");
						out.println("<td>"+rs.getInt(1)+"</td>");
						out.println("<td>"+rs.getString(2)+"</td>");
						out.println("<td>"+rs.getString(3)+"</td>");
						out.println("<td>"+rs.getString(6)+"</td>");
						if(!rs.getString(6).equals("root"))
						{
							out.println("<td><button class='btn btn-info' onclick='buttonFunc(this.value)' data-toggle='modal' data-target='#myModal'  value='"+rs.getInt(1)+"'>Change Role</button></td>");
						}
					}
					%>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="modal fade" id="myModal" role="dialog">
		    <div class="modal-dialog modal-sm">
		      <div class="modal-content">
		      <div class="modal-header">
		      	<h5 class="modal-title" style="float:left"><b>Update Form</b></h5>
		      	<button type="button" style="float:right; background:white;" class="btn btn-default btn-sm" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span></button>
		      </div>
		        <div class="modal-body">
		        	<form action="users.jsp" name="updateForm" method='post'>
		        	<label id="role">Role</label>
		        	<input type="hidden" name="id" id="id" value="">
		        	<select name="user_role" class="form-control">
		        		<option value="user">User</option>
		        		<option value="admin">Admin</option>
		        		<option value="root">root</option>
		        	</select>
		            <input type="submit" value="submit" class="form-control btn-warning">
		            </form>
		        </div>
		      </div>
		    </div>
		  </div>
		  
		  <%
		  String id=request.getParameter("id");
		  String role=request.getParameter("user_role");
		  if(id!=null && role!=null)
		  {
			  String sql="update users set role=? where id=?";
			  PreparedStatement st=con.prepareStatement(sql);
			  st.setString(1,role);
			  st.setString(2,id);
			  int i=st.executeUpdate();
			  if(i>0)
			  {
				  response.sendRedirect("users.jsp");
				  session.setAttribute("roleup","success");
			  }
			  else
			  {
				  out.print("failed");
			  }
			  
		  }
		  
		  %>
		  
		   
		  
		  
	<script>
		function buttonFunc(value)
		{
			document.forms['updateForm']['id'].value=value;
		}
	</script>
</body>
</html>
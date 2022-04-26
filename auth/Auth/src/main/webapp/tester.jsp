<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*,java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Email update</title>
</head>
<script src="validate.js"></script>
<body>
	<% 
		String otp=request.getParameter("otp");
		String email=request.getParameter("data");
		String oldemail=request.getParameter("oldemail");
		out.println(email+" "+otp+" "+oldemail);
		out.println(session.getAttribute("otp"));
		int ss=(Integer)session.getAttribute("otp");
		email=email.trim();
		oldemail=oldemail.trim();
		if(otp!=null)
		{
			int x=Integer.parseInt(otp);
			if(session.getAttribute("otp")!=null)
			{
				if(x==ss)
				{
					String url="jdbc:mysql://localhost:3306/javauserdb";
					Class.forName("com.mysql.cj.jdbc.Driver");
					Connection con=DriverManager.getConnection(url,"root","");
					String query="select * from users where email=?";
					PreparedStatement stmt=con.prepareStatement(query);
					stmt.setString(1,email);
					ResultSet rs=stmt.executeQuery();
					int resultSetSize=0;
					while(rs.next())
					{
						resultSetSize++;
						out.println(rs.getInt(1));
					}
					if(resultSetSize>0)
					{
						session.setAttribute("updatemsg","fail");
						response.sendRedirect("profile.jsp");
					}
					else
					{
						String sql="update users set email=? where email=?";
						PreparedStatement st=con.prepareStatement(sql);
						st.setString(1,email);
						st.setString(2,oldemail);
						int i=st.executeUpdate();
						con.close();
						if(i>0)
						{
							out.println("<script>alert('Email updated successfully.You will be logged out from current session');");
							out.println("logout();");
							out.println("</script>");
						}
					}
				}
				else
				{
					out.println("false");
				}
			}
			
		}
		else
		{
			response.sendRedirect("home.jsp");
		}
	%>
</body>
</html>
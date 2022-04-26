<%@ page import="java.io.*,java.sql.*,java.util.*,Database.*" %>
<%
	String email=request.getParameter("email");
	ValidateUserExists vue=new ValidateUserExists();
	boolean status=vue.validateUserExists(email);
	out.print(status);
%>

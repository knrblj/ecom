package Backend;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class MailSend {
	public  boolean mailSending(String product,String price,String quantity,String email,String address,String name,String phone)
	{
		Properties props=new Properties();
		props.put("mail.smtp.host","smtp.gmail.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");
		props.put("mail.smtp.socketFactory.fallback", "true"); 
		
		String message="<!DOCTYPE html>\n"
				+ "<html>\n"
				+ "<head>\n"
				+ "	<meta charset='utf-8'>\n"
				+ "	<meta name='viewport' content='width=device-width, initial-scale=1'>\n"
				+ "	<title>Thanks For Ordering with us</title>\n"
				+ "	<meta charset='utf-8'>\n"
				+ "	<style type=\"text/css\">\n"
				+ "		.container\n"
				+ "		{\n"
				+ "			width: 100%;\n"
				+ "			margin: auto;\n"
				+ "		}\n"
				+ "		.text-center\n"
				+ "		{\n"
				+ "			text-align: center;\n"
				+ "		}\n"
				+ "		.text-success\n"
				+ "		{\n"
				+ "			color: green;\n"
				+ "		}\n"
				+ "		.panel\n"
				+ "		{\n"
				+ "			border: 2px solid;\n"
				+ "			margin: 2px;\n"
				+ "			padding: 5px;\n"
				+ "			borer-radius: 1px;\n"
				+ "			background: #bcc2bc;\n"
				+ "		}\n"
				+ "		.panel-body\n"
				+ "		{\n"
				+ "			text-align: center;\n"
				+ "		}\n"
				+ "		.mail-body\n"
				+ "		{\n"
				+ "			text-align: center;\n"
				+ "		}\n"
				+ "	</style>\n"
				+ "</head>\n"
				+ "<body>\n"
				+ "	<div class='container text-center text-success'>\n"
				+ "		<div class='panel panel-success'>\n"
				+ "			<div class='panel-head'><h1>Java Ecom Web App</h1></div>\n"
				+ "		</div>\n"
				+ "	</div>\n"
				+ "	<div class='container mail-body '>\n"
				+ "		<h3>Hi "+ name +"</h3>\n"
				+ "		<p>Thanks for using our services. This email is the receipt for your purchase.</p>\n"
				+ "		<p>Your product <b>"+ product +" of quantity "+quantity+"</b> of amount Rs. <b>"+ price +"</b> is ordered with us to the address</p>\n"
				+ "		<p>\n"
				+ name
				+ "		</p>\n"
				+ "		<p>\n"
				+ phone
				+ "		</p>\n"
				+ "		<p>\n"
				+ address
				+ "		</p>\n"
				+ "\n"
				+ "		<br>\n"
				+ "		<div class='panel panel-info'>\n"
				+ "			<div class='panel-body'>Thanks for ordering with us\n"
				+ "			<p>If you have any query, reply to this email</p>\n"
				+ "			</div>\n"
				+ "		</div>\n"
				+ "	</div>\n"
				+ "</body>\n"
				+ "</html>";
		
		Session session=Session.getInstance(props, new javax.mail.Authenticator() {     //create a seesion and validate the password
			      protected PasswordAuthentication getPasswordAuthentication() {  
			    return new PasswordAuthentication("knrblj9@gmail.com","balaji2001");  
			      }  
			    }); 
		//session.setDebug(true);
		try
		{
			MimeMessage msg=new MimeMessage(session);                 //set the message contents of the message.
			msg.setFrom(new InternetAddress("knrblj9@gmail.com"));
			msg.setRecipient(Message.RecipientType.TO,new InternetAddress(email));
			msg.setSubject("Thanks for ordering with us");
			msg.setContent(message,"text/html");
			
			Transport.send(msg);   //send the message
			System.out.println("success");
			return true;
		}
		catch(Exception e)
		{
			System.out.println(e);
		}
		return false;
	}
	
}

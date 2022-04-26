package Backend;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class OtpSend {
	public boolean mailSending(String email, int number) {
		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");
		props.put("mail.smtp.socketFactory.fallback", "true");

		String message = "Your otp is to change email is  : " + number;

		Session session = Session.getInstance(props, new javax.mail.Authenticator() { // create a seesion and validate the password
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("knrblj9@gmail.com", "balaji2001");
			}
		});
		session.setDebug(true);
		try {
			MimeMessage msg = new MimeMessage(session); // set the message contents of the message.
			msg.setFrom(new InternetAddress("knrblj9@gmail.com"));
			msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
			msg.setSubject("Profile Updation");
			msg.setContent(message, "text/html");

			Transport.send(msg); // send the message
			System.out.println("success");
			return true;
		} catch (Exception e) {
			System.out.println(e);
		}
		return false;
	}

}

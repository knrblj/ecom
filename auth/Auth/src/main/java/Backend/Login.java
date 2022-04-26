package Backend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Database.DBUserLogin;
import Database.ValidateUserExists;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out = response.getWriter();

		String email = request.getParameter("email"); // getting data
		String password = request.getParameter("password");

		ValidateUserExists vue = new ValidateUserExists();
		DBUserLogin dbUserLogin = new DBUserLogin();

		try {
			boolean usernotExists = vue.validateUserExists(email); /// check users email id is correct or wrong

			if (usernotExists) // if user not exits it will throw an error like user not found
			{
				Cookie msg = new Cookie("msg", "emailnotfound");
				msg.setMaxAge(1 * 60);
				response.addCookie(msg);
				response.sendRedirect("login.html");
			} else {
				boolean dbLogin = dbUserLogin.userLogin(email, password); // check the enter password is right or wrong
				if (dbLogin) { // if correct enter into home, set the login session cookie with email.
					String encemail = Encryption.enc(email);
					Cookie user = new Cookie("email", encemail);
					user.setMaxAge(60 * 60 * 12); // 12 hours
					response.addCookie(user);
					response.sendRedirect("home.jsp");
				} else // else revert back an error with password wrong message
				{
					Cookie msg = new Cookie("msg", "passwordwrong");
					msg.setMaxAge(1 * 60);
					response.addCookie(msg);
					response.sendRedirect("login.html");
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}

	}

}

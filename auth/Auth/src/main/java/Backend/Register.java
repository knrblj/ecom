package Backend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.validator.routines.EmailValidator;

import Database.DBConnection;
import Database.ValidateUserExists;

/**
 * Servlet implementation class Register
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		String name = request.getParameter("name");
		String email = request.getParameter("email"); // collecting data
		String phone = request.getParameter("phone");
		String password = request.getParameter("password");

		// out.println(name+" "+email+" "+phone+" "+password);
		ValidateUserExists vdu = new ValidateUserExists();
		DBConnection dbcon = new DBConnection();
		try {
			boolean validateUser = vdu.validateUserExists(email); // check whether the user is already exists are not.

			boolean valid = EmailValidator.getInstance().isValid(email);
			if (!valid) {
				HttpSession session = request.getSession();
				session.setAttribute("email", "not_valid");
				response.sendRedirect("index.jsp");

			} else if (validateUser) {
				boolean status = dbcon.insertDataInDB(name, email, phone, password); // if not pass the details into db
				if (status) {
					String encemail = Encryption.enc(email);
					Cookie registerCookie = new Cookie("email", encemail);
					registerCookie.setMaxAge(30 * 60); // in seconds
					response.addCookie(registerCookie);
					response.sendRedirect("home.jsp");
				}
			} else if (!validateUser) {
				Cookie userExists = new Cookie("userExists", "true"); /// exitss set a cookie and revert back to index page
				userExists.setMaxAge(1 * 60);
				response.addCookie(userExists);
				response.sendRedirect("index.jsp");
			} else
				out.print("<h1>Something went wrong</h1>");
		} catch (Exception e) {
			out.println(e);
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	/*
	 * protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { // TODO Auto-generated method stub doGet(request, response); }
	 */

}

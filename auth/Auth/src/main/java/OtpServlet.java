
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Backend.OtpSend;
import Backend.OtpToMobile;

/**
 * Servlet implementation class OtpServlet
 */
@WebServlet("/OtpServlet")
public class OtpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OtpServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		session.setAttribute("otp", null);
		String data = request.getParameter("data");
		String phone = request.getParameter("phone");
		Random rnd = new Random();
		int number = rnd.nextInt(999999);
		OtpSend otp = new OtpSend();
		otp.mailSending(data, number);
		try {
			OtpToMobile.send(phone, number);
		} catch (Exception e) {
			out.print(e);
		}
		session.setAttribute("otp", number);
		out.println("success");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
}

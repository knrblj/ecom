

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CartQuantityUser
 */
@WebServlet("/CartQuantityUser")
public class CartQuantityUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CartQuantityUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		PrintWriter out=response.getWriter();
		String order_id=request.getParameter("order_id");
		String quantity=request.getParameter("quantity");
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			String query="update cart set quantity=? where id=?";
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setString(1, quantity);
			stmt.setString(2, order_id);
			int i=stmt.executeUpdate();
			if(i>0)
			{
				response.sendRedirect("cart.jsp");
			}
			else
			{
				out.print("failed");
			}
		}
		catch(Exception e)
		{
			out.print(e);
		}
		
	}

}

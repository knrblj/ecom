import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

/**
 * Servlet implementation class ValidateCartQuantity
 */
@WebServlet("/ValidateCartQuantity")
public class ValidateCartQuantity extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ValidateCartQuantity() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		PrintWriter out=response.getWriter();
		String email=request.getParameter("email");
		JSONObject obj=new JSONObject();
		HttpSession session = request.getSession();
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			String query="SELECT \n"
					+ "product_name,\n"
					+ "IF(stock>=sum(quantity),'1','0') as state \n"
					+ "from cart,products \n"
					+ "where \n"
					+ "cart.product_id=products.id \n"
					+ "and \n"
					+ "user_id=(SELECT id from users where email=?)\n"
					+ "GROUP BY product_id;";
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setString(1, email);
			ResultSet rs=stmt.executeQuery();
			while(rs.next())
			{
				obj.put(rs.getString(1), rs.getString(2));
			}
			out.print(obj);
			
		}
		catch(Exception e)
		{
			out.print(e);
		}
	}

}

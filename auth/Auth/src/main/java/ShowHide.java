

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
 * Servlet implementation class ShowHide
 */
@WebServlet("/ShowHide")
public class ShowHide extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShowHide() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		PrintWriter out=response.getWriter();
		String id=request.getParameter("id");
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			String query="UPDATE products set status_of_product=(IF(status_of_product='0','1','0')) where id=?"; //it will the status of the product to show to hide or hide to show.
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setString(1, id);
			int i=stmt.executeUpdate();
			if(i>0)
				out.print("success");
			else
				out.print("fail");
			
		}
		catch(Exception e)
		{
			out.print(e);
		}
	}

}

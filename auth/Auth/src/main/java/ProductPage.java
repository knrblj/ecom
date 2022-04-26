
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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class ProductPage
 */
@WebServlet("/ProductPage")
public class ProductPage extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ProductPage() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		JSONArray array = new JSONArray();
		try {
			String query = "select * from products";
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb", "root", "");
			PreparedStatement stmt = con.prepareStatement(query);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();

				obj.put("id", rs.getInt(1));
				obj.put("product", rs.getString(2));
				obj.put("description", rs.getString(3));
				obj.put("cost", rs.getInt(4));
				obj.put("url", rs.getString(5));
				obj.put("time", rs.getString(6));
				obj.put("stock", rs.getInt(7));
				obj.put("status", rs.getString(8));
				obj.put("category", rs.getString(9));
				array.add(obj);
			}
			con.close();
			out.print(array);
		} catch (Exception e) {
			System.out.println(e);
		}

	}
}

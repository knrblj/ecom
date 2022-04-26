
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import Backend.Encryption;

/**
 * Servlet implementation class Cart
 */
@WebServlet("/Cart")
public class Cart extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Cart() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		String product_id = request.getParameter("product_id"); // getting data product_id, quantity
		String quantity = request.getParameter("quantity");
		String email = "";
		Cookie cookie[] = request.getCookies(); // from cookies getting email
		if (cookie.length != 0) {
			for (int i = 0; i < cookie.length; i++) {
				if (cookie[i].getName().equals("email"))
					email = cookie[i].getValue();
			}
		}
		email = Encryption.dec(email);
		int user_id = 0;

		JSONObject obj = new JSONObject(); // creating json object
		HttpSession session = request.getSession(); // creating a session
		obj.put("id", product_id);
		obj.put("email", email);

		String sql = "INSERT INTO cart(user_id,product_id,quantity) values(?,?,?)"; // query to insert into cart
		String query = "select id from users where email=?"; // query to get user_id of email
		String cartCount = "SELECT DISTINCT  user_id,product_id,COUNT(product_id) from cart where user_id=? GROUP by product_id;"; // return the cart count
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb", "root", ""); // creating connection
			PreparedStatement stmt = con.prepareStatement(query);
			stmt.setString(1, email);
			ResultSet rs = stmt.executeQuery();
			while (rs.next())
				user_id = rs.getInt(1);

			if (!product_id.equals("0") && product_id != null) // if product id not null then add the product details into cart db
			{
				int cart_id = 0;
				String cartQuery = "select id from cart where user_id=? and product_id=?";
				PreparedStatement st1 = con.prepareStatement(cartQuery);
				st1.setInt(1, user_id);
				st1.setString(2, product_id);
				ResultSet rs1 = st1.executeQuery();
				while (rs1.next()) {
					cart_id = rs1.getInt(1);
				}
				if (cart_id == 0) {
					PreparedStatement st = con.prepareStatement(sql);
					st.setInt(1, user_id);
					st.setString(2, product_id);
					st.setString(3, quantity);
					int i = st.executeUpdate();
					if (i > 0) {
						obj.put("status", "true"); // create the status of the insertion and passed it into json object
						session.setAttribute("cart", "added");
						response.sendRedirect("home.jsp");
					}
				} else {
					String sql1 = "update cart set quantity=quantity+? where user_id=? and product_id=?";
					PreparedStatement st2 = con.prepareStatement(sql1);
					st2.setInt(1, Integer.parseInt(quantity));
					st2.setInt(2, user_id);
					st2.setString(3, product_id);
					int i = st2.executeUpdate();
					if (i > 0) {
						obj.put("status", "true"); // create the status of the insertion and passed it into json object
						session.setAttribute("cart", "added");
						response.sendRedirect("home.jsp");
					}

				}
			}

			// response.sendRedirect("home.jsp");
			PreparedStatement pr = con.prepareStatement(cartCount); // checking the cart count of the user cart
			pr.setInt(1, user_id);
			int count = 0;
			ResultSet rr = pr.executeQuery();
			while (rr.next())
				count++;
			obj.put("cartcount", count);
			con.close();
		} catch (Exception e) {
			out.print(e);
		}
		out.print(obj);
	}

}

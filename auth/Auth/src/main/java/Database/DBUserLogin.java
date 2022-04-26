package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//Login validation of a user..
public class DBUserLogin {

	public boolean userLogin(String email, String password) throws Exception {
		String url = "jdbc:mysql://localhost:3306/javauserdb";
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, "root", "");
		String role = "";
		String query = "select * from users where email=? and password=?";
		PreparedStatement stmt = con.prepareStatement(query);
		stmt.setString(1, email);
		stmt.setString(2, password);
		ResultSet rs = stmt.executeQuery();

		int resultSetSize = 0;
		while (rs.next()) {
			role = rs.getString(6);
			resultSetSize++;
		}
		con.close();
		if (resultSetSize != 0) {
			return true;
		}
		return false;
	}

	public static void main(String[] args) {
		DBUserLogin dbLogin = new DBUserLogin();
		try {
			boolean status = dbLogin.userLogin("knrbj@gmail.com", "balajik");
			if (status)
				System.out.println("user found");
			else
				System.out.println("user not found");
		} catch (Exception e) {
			System.out.println(e);
		}
	}

}

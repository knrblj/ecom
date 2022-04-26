package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

//insert registeration data into database..
public class DBConnection {

	
	public boolean insertDataInDB(String name,String email,String phone,String password) throws Exception
	{
		String url="jdbc:mysql://localhost:3306/javauserdb";
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection(url,"root","");
		String query="INSERT INTO users(name,email,phone,password) VALUES (?,?,?,?)";
		PreparedStatement stmt=con.prepareStatement(query);
		stmt.setString(1,name);
		stmt.setString(2, email);
		stmt.setString(3, phone);
		stmt.setString(4, password);
		
		int status=stmt.executeUpdate();
		con.close();
		if(status>=1)
			return true;
		
		return false;
	}
	public static void main(String[] args) 
	{
		DBConnection dbcon=new DBConnection();
		try {
		boolean status=dbcon.insertDataInDB("name2","balaji@gmail.com","7305744010","balajik");
		if(status)
			System.out.println("success");
		else
			System.out.println("failed");
		}
		catch(Exception e)
		{
			System.out.println(e);
		}
	}

}

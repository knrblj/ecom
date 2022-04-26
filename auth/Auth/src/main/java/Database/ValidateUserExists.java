package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//Check the user is alreay exists are not..
public class ValidateUserExists {
	
	public boolean validateUserExists(String email) throws Exception
	{
		String url="jdbc:mysql://localhost:3306/javauserdb";
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con=DriverManager.getConnection(url,"root","");
		String query="select * from users where email=?";
		PreparedStatement stmt=con.prepareStatement(query);
		
		stmt.setString(1,email);
		ResultSet rs=stmt.executeQuery();
		int resultSetSize=0;
		while(rs.next())
			resultSetSize++;
		con.close();
		if(resultSetSize==0) //if resultSet is zero means the user not found
			return true;
		return false;
	}
	
	
	
	public static void main(String[] args) 
	{
		ValidateUserExists vue=new ValidateUserExists();
		try
		{
			if(vue.validateUserExists("knrblj9@gmail.com"))
				System.out.println("user not found");
			else
				System.out.println("User already Exists");
		}
		catch(Exception e)
		{
			System.out.println(e);
		}
		
	}

}

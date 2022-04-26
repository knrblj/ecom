package Backend;
import java.sql.*;
public class QunatityCheckNUpdate
{
	
	public int qunatityCheck(int id)    //check the quantity of the given product with id,
	{
		int stock=0;
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			String query="select stock from products where id=?";
			PreparedStatement stmt=con.prepareStatement(query);
			stmt.setInt(1, id);
			ResultSet rs=stmt.executeQuery();
			while(rs.next())
				stock=rs.getInt(1);
			con.close();
		}
		catch(Exception e)
		{
			System.out.println(e);
			return 0;
		}
		
		return stock;   //return the stock of the product.
	}
	
	public boolean quantityUpdate(int id,int quantity)   //update the product quantity after ordering is complete
	{
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb","root","");
			String query="update products set stock=stock-? where id=?";
			PreparedStatement stmt=con.prepareStatement(query);
			
			stmt.setInt(1, quantity);
			stmt.setInt(2, id);
			int i=stmt.executeUpdate();
			con.close();
			if(i>0)
				return true;
		}
		catch(Exception e) 						//return true if change happend else false..
		{
			System.out.println(e);
			return false;         
		}
		return false;
	}
	
	

}

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class UploadFile
 */
@WebServlet("/UploadFile")
public class UploadFile extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String name = null;
		String price = null;
		String description = null; // setting the values into null
		String image = null;
		String quantity = null;
		String id = null;
		String selection = null;
		response.setContentType("text/html"); // set response type to html
		PrintWriter out = response.getWriter();
		boolean isMultipartContent = ServletFileUpload.isMultipartContent(request); /// getting the complete data from multipart
		if (!isMultipartContent) {
			return; // if multipart is null return null value
		}
		FileItemFactory factory = new DiskFileItemFactory(); // creating a factory object
		ServletFileUpload upload = new ServletFileUpload(factory); // that object passed into fileuploadsevlet
		try {
			List<org.apache.commons.fileupload.FileItem> fields = upload.parseRequest(request); // created a list of maps based on the data we collected from the form
			Iterator<FileItem> it = fields.iterator();
			if (!it.hasNext()) // iterate the list by using iterator
			{
				return;
			}
			while (it.hasNext()) // running the iterator and set the values by checking the data variable names.
			{
				FileItem fileItem = it.next();
				boolean isFormField = fileItem.isFormField();
				if (isFormField) {
					if (id == null) {
						if (fileItem.getFieldName().equals("id")) {
							id = fileItem.getString();
							// out.print(id+" ");
						}
					}
					if (name == null) {
						if (fileItem.getFieldName().equals("name")) {
							name = fileItem.getString();
							// out.print(name+" ");
						}
					}
					if (price == null) {
						if (fileItem.getFieldName().equals("price")) {
							price = fileItem.getString();
							// out.print(price+" ");
						}
					}
					if (selection == null) {
						if (fileItem.getFieldName().equals("selection")) {
							selection = fileItem.getString();
							// out.print(price+" ");
						}
					}
					if (quantity == null) {
						if (fileItem.getFieldName().equals("quantity")) {
							quantity = fileItem.getString();
							// out.print(price+" ");
						}
					}
					if (description == null) {
						if (fileItem.getFieldName().equals("description")) {
							description = fileItem.getString();
							// out.print(description+" ");
						}
					}
				} else {
					if (fileItem.getSize() > 0) {
						fileItem.write(new File("/home/local/ZOHOCORP/balaji-pt5344/uploads/" + fileItem.getName()));
						image = "uploads/" + fileItem.getName();
						// out.print(image);
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		/// inserting into db
		if (id != null && name != null && price != null && description != null && quantity != null && selection != null) // Update the product db with new values, if we get the id of product it is
																															// updating of product
		{
			try {
				String query = "";
				if (image != null) // if image is null we wont update image
					query = "update products set product_name=?,product_cost=?,product_description=?,stock=?,status_of_product=?,product_image=? where id=?";
				else // or else we will update image
					query = "update products set product_name=?,product_cost=?,product_description=?,stock=?,status_of_product=? where id=?";
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb", "root", "");
				PreparedStatement stmt = con.prepareStatement(query);
				stmt.setString(1, name);
				stmt.setString(2, price);
				stmt.setString(3, description);
				stmt.setString(4, quantity);
				stmt.setString(5, selection);
				if (image != null) {
					stmt.setString(6, image);
					stmt.setString(7, id);
				} else
					stmt.setString(6, id);
				int i = stmt.executeUpdate();
				if (i > 0) {
					HttpSession session = request.getSession();
					session.setAttribute("admsg", "update");
					response.sendRedirect("add.jsp");
				} else {
					out.print("failed");
				}
			} catch (Exception e) {
				out.print(e);
			}
		} else if (name != null && price != null && description != null && image != null && quantity != null) // Inserting a new product into the product DB
		{
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/javauserdb", "root", "");
				String query = "INSERT INTO products(product_name, product_description, product_cost,product_image,stock) values(?,?,?,?,?)";
				PreparedStatement stmt = con.prepareStatement(query);
				stmt.setString(1, name);
				stmt.setString(2, description);
				stmt.setString(3, price);
				stmt.setString(4, image);
				stmt.setString(5, quantity);
				int i = stmt.executeUpdate();
				con.close();
				if (i > 0) {
					HttpSession session = request.getSession();
					session.setAttribute("admsg", "add");
					response.sendRedirect("add.jsp");
				} else {
					out.println("failed to add a product");
				}
			} catch (Exception e) {
				System.out.println(e);
			}
		} else {
			out.print("failed");
		}
	}
}

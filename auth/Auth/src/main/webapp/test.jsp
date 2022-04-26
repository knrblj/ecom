<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
 <script src="validate.js"></script>
 <title>File Upload</title>
</head>
<body>
	<br>
	<br>
	<div class="col-lg-3"></div>
	<div class="col-lg-6">
	<form action="UploadFile" method="POST" name="updateProduct" enctype = "multipart/form-data">
		        	<div class="form-group">
						<label for="name">Product Name</label>
						<input type="text" id="name" name="name" class="form-control" placeholder="Product name (* Required field)" required >
					</div>
					
					<div class="form-group">
						<label for="price">Product price</label>
						<input type="number" id="price" name="price" class="form-control" placeholder="Product price (* Required field)" required>
					</div>
					
					<div class="form-group">
						<label for="description">Product Description</label>
						<textarea class="form-control" id="description" name="description"  rows="4" required></textarea>
					</div>
				
					<div class="form-group">
						<label for="image">Product Image url</label>
						<input type="file" accept="image/*" name="image" id="image" class="form-control" placeholder="Product image url (* Required field)" required>
					</div>
					
					<div class="form-group">
						<input type="submit" value="Update PRODUCT" class="form-control btn-success">
					</div>
		            </form>
	</div>
	<div class="col-lg-3"></div>
	<script >
	
	function fileFunc()
	{
		var image=document.getElementById("file").files[0];
		var imgname=image.name;
		var size=image.size;
		if(size <= 1048576)
		{
			document.forms['test']['url'].value=imgname;
			//console.log(document.getElementById('name').value);
			//console.log(document.getElementById('url').value);
			return false;
		}
		else
			document.getElementById("res").innerHTML="<div class='text-danger'>* File size should be less than 1MB</div>";
		return false;
	}
	
	</script>
</body>
</html>
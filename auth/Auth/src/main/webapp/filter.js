function filterArray(value,array)
{
	var filtered=[];
	for(var i=0;i<array.length;i++)
	{
		if(array[i].category.includes(value))
		{
			filtered.push(array[i]);
		}
	}
	return filtered;
}
	
function searchFilter(value,array)
{
	var filtered=[];
	var val=value.toLowerCase();
	for(var i=0;i<array.length;i++)
	{
		if(array[i].description.toLowerCase().includes(val))
		{
			filtered.push(array[i]);
		}
	}
	return filtered;
}
		
function priceFilter(min,max,array)
{
	var filtered=[];
	for(var i=0;i<array.length;i++)
	{
		if(parseInt(array[i].cost) >= parseInt(min) && parseInt(array[i].cost) <= parseInt(max) )
		{
			filtered.push(array[i]);
		}
	}
	//console.log(filtered);
	return filtered;
}
		
var temp =null
$.ajax({
	method:'GET',
	url:'ProductCall',
	async: false,
	success:function(response){
	temp = $.parseJSON(response);
	}
})
		
function runFunc()
{
	var data=[];
	for(var i=0;i<temp.length;i++)
	{
		data[i]=temp[i];
	}	
	var value=document.getElementById("sorting").value;
	var category=document.getElementById("category").value;
	var price=document.getElementById("rangePrimary").value;
	var search=document.getElementById("search").value;
			
			
	var min=price.split(";")[0];
	var max=price.split(";")[1];
			
	data=priceFilter(min,max,data);
			
			
	if(search.trim()!='')
	{
		data=searchFilter(search,data);
	}
				
	if(category=='1')
	{
		data=filterArray('Men',data);
	}
	else if(category=='2')
	{
		data=filterArray('women',data);
	}
	if(category=='3')
	{
		data=filterArray('accessories',data);
	}
			
	if(value=='1')
		data=data.sort((a,b)=>a['cost']>b['cost']?1:-1);
	else if(value=='2')
		data=data.sort((a,b)=>a['cost']<b['cost']?1:-1);
	else if(value=='3')
		data=data.sort((a,b)=>a['product']>b['product']?1:-1);
	else if(value=='4')
		data=data.sort((a,b)=>a['product']<b['product']?1:-1);
	else if(value=='5')
		data=data.sort((a,b)=>a['hours']>b['hours']?1:-1);
	productFunc(data);
}
		
function productFunc(temp)
{
	var res=document.getElementById("result");
	res.innerHTML='';
			
	for(var i=0;i<temp.length;i++)
	{
		var string="";
		string+=`
			<div class='col-lg-4' style='border:1px solid;'>
			<br>`;
		if(parseInt(temp[i].hours)<24 && parseInt(temp[i].stock)>0)
		{
			string+=`<span class='new_product'>New</span>`;
		}
		if(parseInt(temp[i].stock) <=5 && parseInt(temp[i].stock)>0)
		{
			string+=`<span style='float:right; font-size:12px;' class='label label-danger'>Only Few Left</span>`;
		}
		if(parseInt(temp[i].stock)==0)
		{
			string+=`<span style='float:right; font-size:12px;' class='label label-danger'>Comming Soon</span>`;
		}
			string+=`<div style='width:100px; height:100px'><img class='rounded img-responsive center-block'  height='100' width='100'  src='http://localhost:8081/${temp[i].url}'></div>
					<div class='text-center'><h1> ${temp[i].product}</h1></div>
					<h4> <b>RS. ${temp[i].cost} /- only</b></h4>
					<div class='word'>${temp[i].description}</div>
					<div style='height:75px;'>
				`;
		if(temp[i].stock>0)
		{
			string+=`
				<form  method='post' onsubmit='return updateCart()' action='Cart'>
				<label for=quantity>Quantity</label><input type=number id=quantity name=quantity min=1 max=10 value='1' required><br>
				<input type=hidden value=${temp[i].id} id=product_id name=product_id></input>
				<div style='float:left'><button class='btn btn-success'>Add to Cart</button></div>
				</form>
				<div style='float:right'><a class='btn btn-success' href='order.jsp?id=${temp[i].id}'>Buy Now</a></div>`;
		}
		else
		{
			string+=`<br><span class='sold-out-overlay'>Sold Out </span>`;
		}
		string+=`</div></div>`;
				res.innerHTML+=string;
			}
		}
$('#rangePrimary').ionRangeSlider({ type: 'double', grid: true, min: 0, max: 1000, step: 50,from:0,to:1000,prefix: 'RS'});
productFunc(temp);

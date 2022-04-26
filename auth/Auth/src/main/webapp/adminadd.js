var temp =null
$.ajax({
	method:'GET',
	url:'ProductPage',
	async: false,
	success:function(response){
		temp = $.parseJSON(response);
	}
})



function buildData(temp)
{
	var res=document.getElementById("result");
	res.innerHTML='';
	for(var i=0;i<temp.length;i++)
	{
		var string='';
		string+=`
			<tr>
			<td><img class='rounded' height=50 width=50 src='http://localhost:8081/${temp[i].url}'></td>
			<td>${temp[i].id}</td>
			<td>${temp[i].product}</td>
			<td>${temp[i].stock}</td>
			<td>${temp[i].cost}</td>
		`;
		
		if(temp[i].status=="0")
		{
			string+=`<td><button onclick='showHideFunc(this.value)' class='btn btn-success' value='${temp[i].id}'><span class='glyphicon glyphicon-eye-open'></span></button></td>`;
		}
		else
		{
			string+=`<td><button onclick=showHideFunc(this.value) class='btn btn-danger' value='${temp[i].id}'><span class='glyphicon glyphicon-eye-close'></span></button></td>`;
		}
		string+=`
			<td  class='word'>${temp[i].description}</td>
		`;
		
		var st=temp[i].id+"|split|"+temp[i].product+"|split|"+temp[i].cost+"|split|"+temp[i].description+"|split|"+temp[i].url+"|split|"+temp[i].stock;
		
		string+=`<td><button onclick='editForm(this.value)' value='${st}' class='btn btn-primary' data-toggle='modal' data-target='#myModal' ><span class='glyphicon glyphicon-edit'></span></button></td>
				<td><a class='btn btn-danger' href='delete.jsp?id=${temp[i].id}'><span class='glyphicon glyphicon-trash'></span></a></td>
				</tr>
		`;
		res.innerHTML+=string;
	}
}
buildData(temp);

function searchFilter(value,array)
{
	var filtered=[];
	var val=value.toLowerCase();
	for(var i=0;i<array.length;i++)
	{
		if(array[i].product.toLowerCase().includes(val))
		{
			filtered.push(array[i]);
		}
	}
	return filtered;
}

//search function of products
function searchFunc()
{
	var data=[];
	for(var i=0;i<temp.length;i++)
	{
		data[i]=temp[i];
	}
			
	var search=document.getElementById('search').value;
	data=searchFilter(search,data);
	buildData(data);
}

 $('th').on('click', function(){
	
	myArray=[]
	for(var i=0;i<temp.length;i++)
	{
		myArray[i]=temp[i];
	}
    var column = $(this).data('colname')
    var order = $(this).data('order')
    var text = $(this).html()
    if(column==null)
		return null;
    text = text.substring(0, text.length - 1);
      
     if (order == 'desc'){
        myArray = myArray.sort((a, b) => a[column] > b[column] ? 1 : -1)
        $(this).data("order","asc");
        text += '&#9660'
     }else{
        myArray = myArray.sort((a, b) => a[column] < b[column] ? 1 : -1)
        $(this).data("order","desc");
        text += '&#9650'
     }
     
    $(this).html(text);
    buildData(myArray); 
    });






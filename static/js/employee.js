$(document).ready(function(){
	$('[data-toggle="tooltip"]').tooltip();
	var actions = $("table td:last-child").html();
	// Append table with add row form on add new button click
    $(".add-new").click(function(){
		$(this).attr("disabled", "disabled");
		var index = $("table tbody tr:last-child").index();
        var row = '<tr>' +
            '<td><input type="text" class="form-control" name="id" id="id" disabled="true" value="999"></td>' +
            '<td><input type="text" class="form-control" name="first_name" id="first_name" placeholder="First Name"></td>' +
            '<td><input type="text" class="form-control" name="last_name" id="last_name" placeholder="Last Name"></td>' +
            '<td><input type="text" class="form-control" name="full_name" id="full_name" disabled="true" value="NA"></td>' +
            '<td><input type="text" class="form-control" name="address" id="address" placeholder="Address"></td>' +
            '<td><input type="text" class="form-control" name="emp_type" id="emp_type" placeholder="Type"></td>' +
            '<td><input type="text" class="form-control" name="phone" id="phone" placeholder="Phone"></td>' +
            '<td><input type="text" class="form-control" name="ssn" id="ssn" placeholder="SSN"></td>' +
			'<td>' + actions + '</td>' +
        '</tr>';
    	$("table").append(row);		
		$("table tbody tr").eq(index + 1).find(".add, .edit").toggle();
        $('[data-toggle="tooltip"]').tooltip();
    });
	// Add row on add button click
	$(document).on("click", ".add", function(){
		var empty = false;
		var input = $(this).parents("tr").find('input[type="text"]');
        input.each(function(){
			if(!$(this).val()){
				$(this).addClass("error");
				empty = true;
			} else{
                $(this).removeClass("error");
            }
		});
		$(this).parents("tr").find(".error").first().focus();
		if(!empty){
			input.each(function(){
				$(this).parent("td").html($(this).val());
			});			
			$(this).parents("tr").find(".add, .edit").toggle();
			$(".add-new").removeAttr("disabled");
		}		
    });
	// Edit row on edit button click
	$(document).on("click", ".edit", function(){		
        $(this).parents("tr").find("td:not(:last-child)").each(function(){
			$(this).html('<input type="text" class="form-control" value="' + $(this).text() + '">');
		});		
		$(this).parents("tr").find(".add, .edit").toggle();
		$(".add-new").attr("disabled", "disabled");
    });
	// Delete row on delete button click
	$(document).on("click", ".delete", function(){
        $(this).tooltip('hide');
        $(this).parents("tr").remove();
		$(".add-new").removeAttr("disabled");
    });
});

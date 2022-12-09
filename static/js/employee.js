$(document).ready(function () {
    document.querySelectorAll('.delete').forEach(each => {
        // for each one, attach an eventlistener of onclick
        each.onclick = () => {
            // send request to your backend delete url
            fetch("/employee/delete/" + each.id, {
            }).then(function(){
                window.location.href = '/employee';
              });
        };
    });
    $('table .edit').click(function() {
        var tr = $(this).closest('tr');
        var id = tr.children('td:eq(0)').text();
        var finame = tr.children('td:eq(1)').text();
		var lname = tr.children('td:eq(2)').text();
		var funame = tr.children('td:eq(3)').text();
        var address = tr.children('td:eq(4)').text();
		var type = tr.children('td:eq(5)').text();
        var phone = tr.children('td:eq(6)').text();
        var ssn = tr.children('td:eq(7)').text();

        // console.log(id, name, desc);
        $('#employeeId').val(id);
		$('#finame').val(finame);
        $('#lname').val(lname);
		$('#funame').val(funame);
        $('#address').val(address);
		$('#type').val(type);
        $('#phone').val(phone);
        $('#ssn').val(ssn);
      });
});
$(document).ready(function () {
    document.querySelectorAll('.delete').forEach(each => {
        // for each one, attach an eventlistener of onclick
        each.onclick = () => {
            // send request to your backend delete url
            fetch("/supplier/delete/" + each.id, {
            }).then(function(){
                window.location.href = '/supplier';
              });
        };
    });
    $('table .edit').click(function() {
        var tr = $(this).closest('tr');
        var id = tr.children('td:eq(0)').text();
        var name = tr.children('td:eq(1)').text();
        var phone = tr.children('td:eq(2)').text();
        var address = tr.children('td:eq(3)').text();

        // console.log(id, name, desc);
        $('#supplierId').val(id);
        $('#supplierName').val(name);
        $('#supplierPhone').val(phone);
        $('#supplierAddress').val(address);
      });
});
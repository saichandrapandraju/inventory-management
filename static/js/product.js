$(document).ready(function () {
    document.querySelectorAll('.delete').forEach(each => {
        // for each one, attach an eventlistener of onclick
        each.onclick = () => {
            // send request to your backend delete url
            fetch("/product/delete/" + each.id, {
            }).then(function(){
                window.location.href = '/product';
              });
        };
    });
    $('table .edit').click(function() {
        var tr = $(this).closest('tr');
        var id = tr.children('td:eq(0)').text();
        var name = tr.children('td:eq(1)').text();
        var price = tr.children('td:eq(2)').text();
        var desc = tr.children('td:eq(3)').text();
        var qty = tr.children('td:eq(4)').text();
        var man_date = tr.children('td:eq(5)').text();
        var exp_date = tr.children('td:eq(6)').text();
        var location = tr.children('td:eq(7)').text();
        var brand = tr.children('td:eq(8)').text();
        var category = tr.children('td:eq(9)').text();
        var supplier = tr.children('td:eq(10)').text();


        $('#productId').val(id);
        $('#productName').val(name);
        $('#productPrice').val(price);
        $('#productDescription').val(desc);
        $('#productQuantity').val(qty);
        $('#productManDate').val(man_date);
        $('#productExpDate').val(exp_date);
        $('#productLocation').val(location);
        $('#productBrand').val(brand);
        $('#productCategory').val(category);
        $('#productSupplier').val(supplier);

      });
});
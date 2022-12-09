$(document).ready(function () {
    document.querySelectorAll('.delete').forEach(each => {
        // for each one, attach an eventlistener of onclick
        each.onclick = () => {
            // send request to your backend delete url
            fetch("/category/delete/" + each.id, {
            }).then(function(){
                window.location.href = '/category';
              });
        };
    });
    $('table .edit').click(function() {
        var tr = $(this).closest('tr');
        var id = tr.children('td:eq(0)').text();
        var name = tr.children('td:eq(1)').text();
        var desc = tr.children('td:eq(2)').text();

        // console.log(id, name, desc);
        $('#categoryId').val(id);
        $('#categoryName').val(name);
        $('#categoryDescription').val(desc);
      });
});
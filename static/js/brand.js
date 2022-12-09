$(document).ready(function () {
    document.querySelectorAll('.delete').forEach(each => {
        // for each one, attach an eventlistener of onclick
        each.onclick = () => {
            // send request to your backend delete url
            fetch("/brand/delete/" + each.id, {
            }).then(function(){
                window.location.href = '/brand';
              });
        };
    });
    $('table .edit').click(function() {
        var tr = $(this).closest('tr');
        var name = tr.children('td:eq(0)').text();

        $('#brandName').val(name);
      });
});
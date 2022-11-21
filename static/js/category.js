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
});
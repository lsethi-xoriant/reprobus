$(document).ready(function() {
    $("#usersearch").select2({
      placeholder: "Search for user",
      allowClear: true,
      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/users/usersearch",
        dataType: 'json',
        data: function (term, page) {
            return {
              q: term, // search term
              page_limit: 10
              };
    },
    results: function (data, page) { // parse the results into the format expected by Select2.
            return {results: data.searchSet};
            }
    },
    initSelection: function(element, callback) {
            var id=$(element).val();
            if (id!=="") {
                $.ajax("/users/"+id+".json", {
                    dataType: "json"
                }).done(function(data) {
                    var selected = {id: element.val(), text: data.name };
                    callback(selected);
                });
            }
        },
    dropdownCssClass: "bigdrop" // apply css that makes the dropdown taller
    });
  
 });

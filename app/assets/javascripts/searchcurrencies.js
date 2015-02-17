$(document).ready(function() {
    $("#currencysearch").select2({
      //placeholder: "Search for user",
      allowClear: true,

      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/static_pages/currencysearch",
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
        var id = $(element).val();
        if (id!=="") {
              var item = id.split(':'); 
              var selected = {id: item[0], text: item[1] };
              callback(selected);
         }       
      },
    dropdownCssClass: "bigdrop" // apply css that makes the dropdown taller
    });

; });
$(document).ready(function() {
    $("#stopoversearch").select2({
      //placeholder: "Search for user",
      allowClear: true,
      multiple: true,
      tokenSeparators: [",", " "],
      
      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/enquiries/stopoversearch",
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
        var data = [];
        $(element.val().split(",")).each(function(i) {
          var item = this.split(':');
          data.push({
            id: item[0],
            text: item[1]
          });
        });
        //$(element).val('');
        callback(data);
      },
    dropdownCssClass: "bigdrop" // apply css that makes the dropdown taller
    });

 });
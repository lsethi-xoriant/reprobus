$(document).ready(function() {
    $("#carriersearch").select2({
      //placeholder: "Search for user",
      allowClear: true,
      multiple: true, 
      tokenSeparators: [",", " "],
      
      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/enquiries/carriersearch",
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
    // var elementText;
    // elementText = element.attr("data_init_text");
    // console.log(elementText);  // HG need to pull in values from page to put into call back. 
     
      var data = [];
      var elementText;
      var elementID;
     // elementText = element.attr('data_id');
      //elementID = element.attr('data_text');
     // console.log(elementText);
     // console.log(elementID);
     // console.log("hi hamish2");

      $(element.val().split(",")).each(function () {
        data.push({id: this, text: this});
      });
      callback(data);
      //var data = {id: element.val(), text: element.val()};
      //console.log("hi hamish2");
       // callback(data);
    },
    dropdownCssClass: "bigdrop" // apply css that makes the dropdown taller
    });
  
 });
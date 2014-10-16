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
//     initSelection: function(element, callback) {
//             var id=$(element).val();
      
//       console.log("hi hamish");
//       console.log(id);
//             var str_array = id.split(',');
//             for(var i = 0; i < str_array.length; i++) {
//                console.log(str_array[i]);
//               if (str_array[i]!=="") {
//                   $.ajax("/admin/carriers/"+str_array[i]+".json", {
//                       dataType: "json"
//                   }).done(function(data) {
//                       var selected = {id: element.val(), text: data.name };
//                       callback(selected);
//                   });
//               }
//             }
//         },
            formatSelection: formatSelection,
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

    function formatSelection(data) {
        return data.text;
    };

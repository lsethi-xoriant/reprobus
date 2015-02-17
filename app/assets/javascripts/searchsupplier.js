$(document).ready(function() {
    $("#sup_select").select2({
      placeholder: "Search for customer",
      allowClear: true,
      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/suppliers/suppliersearch",
        dataType: 'json',
        data: function (term, page) {
            return {
              q: term, // search term
              page_limit: 10
              };
    },
    results: function (data, page) { // parse the results into the format expected by Select2.     
            return {results: data.searchSet};}
    },
    initSelection: function(element, callback) {
            var id=$(element).val();
            if (id!=="") {
                $.ajax("/suppliers/"+id+".json", {
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

$(document).ready(function() {
  $("#sup_select").on("select2-selecting", function(e) { 
    //alert ("selecting val="+ e.val+" choice="+ JSON.stringify(e.choice));
    $('#supplierDefaultCurrency').val(e.choice.currency);})
});
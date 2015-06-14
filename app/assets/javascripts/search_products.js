$(document).ready(function() {
  var destination_search_term;
  
  initProductSelect2();  // intialise select drop downs
  
 var $eventSelect = $(".select2-destinations");
  $eventSelect.on("select2:select", function (e) {
    destination_search_term = $(this).val();
console.log(destination_search_term);
    var nextProdField = $(this).closest('.field').find(".select2-products");
    
    nextProdField.select2({
      ajax: {
        url: "/searches/product_search",
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term, // search term
            destination: destination_search_term,
            page: params.page
          };
        },
        processResults: function (data, page) {
          // parse the results into the format expected by Select2.
          // since we are using custom formatting functions we do not need to
          // alter the remote JSON data
          return {
            results: data.items
          };
        },
        cache: true
      },
      escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
      minimumInputLength: 1,
      templateResult: formatProduct,
      templateSelection: formatProductSelection
    });
    });      

 });
 


  function formatProduct (product) {
    var markup = "";
    if (product.text) {
      markup += '<div><strong>' + product.type + '</strong></div>';
      markup += '<div>' + product.name + ' | ' + product.city + ' | ' + product.country + '</div>';
    }
    return markup;
  }

  function formatProductSelection (product) {
    return product.text;
  }
  
 
  function initProductSelect2() {
    $(".select2-products").select2({
      ajax: {
        url: "/searches/product_search",
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            q: params.term, // search term
            destination: destination_search_term,
            page: params.page
          };
        },
        processResults: function (data, page) {
          // parse the results into the format expected by Select2.
          // since we are using custom formatting functions we do not need to
          // alter the remote JSON data
          return {
            results: data.items
          };
        },
        cache: true
      },
      escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
      minimumInputLength: 1,
      templateResult: formatProduct,
      templateSelection: formatProductSelection
    });

}
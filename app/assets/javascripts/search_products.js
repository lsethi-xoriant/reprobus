var destination_search_term = "";
  
  
$(document).ready(function() {
  initProductSelect2();  // intialise select drop downs
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

function getDestinationSearchTerm(theSelect2Element) {
  console.log(theSelect2Element);
  var nextProdField = $(theSelect2Element).closest('.field').find(".select2-destinations");
  console.log(nextProdField);
  console.log("searc tem = " + $(nextProdField).val());
  return $(nextProdField).val();
}

function initProductSelect2() {
  var theSelect2Element = null;
  $(".select2-products").select2({
    ajax: {
      url: "/searches/product_search",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term, // search term
          destination: getDestinationSearchTerm(theSelect2Element),
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
  }).on('select2:open', function(e){ 
   theSelect2Element = e.currentTarget;});
  /*
  // reinit if destination field udpated with destination field set. i.e itinerary templage field. 
  var $eventSelect = $(".select2-destinations");
  $eventSelect.on("select2:select", function (e) {
    destination_search_term = $(this).val();
    // find closes select products field in the field container. 
    var nextProdField = $(this).closest('.field').find(".select2-products");
    // now re-init it with the destination search params set. 
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
  });    */  
}
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
  var nextProdField = $(theSelect2Element).closest('.row').find(".select2-destinations");
  return $(nextProdField).val();
}

function getCountrySearchTerm(theSelect2Element) {
  var nextProdField = $(theSelect2Element).closest('.row').find(".select2-countries");
  return $(nextProdField).val();
}

function getTypeSearchTerm(theSelect2Element) {
  var nextProdField = $(theSelect2Element).closest('.row').find(".type-itineraries");
  // materialize does funny stuff with select boxes, so return value to get right value
  return $(nextProdField)[1].value;
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
          country: getCountrySearchTerm(theSelect2Element),
          type: getTypeSearchTerm(theSelect2Element),
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

   
  /* on selection of product set other fields in row - i.e the itinerary templage form */
  var $eventSelect = $(".select2-products");
  $eventSelect.on("select2:select", function (e) {
  var nextProdField = $(this).closest('.field').find(".product_details");
  nextProdField.val(e.params.data.type + " | "  + e.params.data.name + " | "  + e.params.data.city + " | "  + e.params.data.country);
  nextProdField.next().addClass('active'); // set label to be active.
  
  // add cruises if necessary....
  
  });  
}
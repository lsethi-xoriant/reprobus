$(document).ready(function() {

  initCurrencySelect2();  // intialise select drop downs
});

  function formatCurrency (searchOb) {
    if (searchOb.loading) return searchOb.text;
    var markup = "";
    if (searchOb.text) {
      markup += '<div>' + searchOb.text + '</div>';
    }
    return markup;
  }

  function formatCurrencySelection (searchOb) {
    return searchOb.text;
  }
 
  function initCurrencySelect2() {
   $(".select2-currencies").select2({
    ajax: {
      url: "/searches/currency_search",
      dataType: 'json',
      delay: 200,
      data: function (params) {
        return {
          q: params.term, // search term
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
   // minimumInputLength: 1,
    templateResult: formatCurrency,
    templateSelection: formatCurrencySelection
   });
   
/*    var $eventSelect = $(".select2-currencies.supplier-itinerary-price");
    $eventSelect.on("select2:select", function(e) {
      var data = e.params.data;
      var sellRateField = $(this).closest('.row').find(".sell_currency_rate");
      sellRateField.val(data.currency_rate);
    });   */
   
  }
  

  

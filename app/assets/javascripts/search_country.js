$(document).ready(function() {
  
  initCountrySelect2();  // intialise select drop downs
});

function formatCountry (searchOb) {
  if (searchOb.loading) return searchOb.text;
  var markup = "";
  if (searchOb.text) {
    markup += '<div>' + searchOb.text + '</div>';
  }
  return markup;
}

function formatCountrySelection (searchOb) {
  return searchOb.text;
}
 
function initCountrySelect2() {
  // noajax version
  $(".select2-countries-noajax").select2();   
  
  //ajax version
  $(".select2-countries").select2({
    ajax: {
      url: "/searches/country_search",
      dataType: 'json',
      delay: 100,
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
    templateResult: formatCountry,
    templateSelection: formatCountrySelection
  });
  
  // handle items being selected - clear related fields. 
  
  $('.select2-countries').on("select2:select", function(e) {
    // if countries field changes clear related fields if they exist -  destinations, products....
    $(this).closest(".row").find(".select2-destinations").val(null).trigger("change");
    $(this).closest(".row").find(".select2-products").val(null).trigger("change");
    $(this).closest(".row").find(".itinerary-number-days").val("0");
    $(this).closest('.field').find(".cruise-info").hide();
    $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
  });  
  
  $('.select2-countries-noajax').on('select2:select', function(e) {
    // if countries field changes clear related fields if they exist -  destinations, products....
    //$(this).closest(".row").find(".select2-destinations-noajax").val(null).trigger("change");
    $(this).closest(".row").find(".select2-destinations").val(null).trigger("change");
    $(this).closest(".row").find(".select2-products").val(null).trigger("change");
    $(this).closest(".row").find(".itinerary-number-days").val("0");
    $(this).closest('.field').find(".cruise-info").hide();
    $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
  });      
}


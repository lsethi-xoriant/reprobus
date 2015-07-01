$(document).ready(function() {
  initDestinationSelect2();  // intialise select drop downs
});

function formatDestination (searchOb) {
  if (searchOb.loading) return searchOb.text;
  var markup = "";
  if (searchOb.text) {
    markup += '<div>' + searchOb.text + '</div>';
  }
  return markup;
}

function formatDestinationSelection (searchOb) {
  return searchOb.text;
}

function getCountrySearchTerm(theSelect2Element) {
  var nextProdField = $(theSelect2Element).closest('.row').find(".select2-countries");
  return $(nextProdField).val();
} 
 
function initDestinationSelect2() {
  var theSelect2Element = null;
  $(".select2-destinations").select2({
    ajax: {
      url: "/searches/destination_search",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term, // search term
          country: getCountrySearchTerm(theSelect2Element),
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
    templateResult: formatDestination,
    templateSelection: formatDestinationSelection
  }).on('select2:open', function(e){ 
    theSelect2Element = e.currentTarget;});
}

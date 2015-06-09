$(document).ready(function() {

  initCustomerSelect2();  // intialise select drop downs
  
  function formatCustomer (searchOb) {
    if (searchOb.loading) return searchOb.text;
    var markup = "";
    if (searchOb.text) {
      markup += '<div><strong>' + searchOb.title + " " + searchOb.text + '</strong></div>';
      markup += '<div>' + searchOb.email + '</div>';
      markup += '<div>' + searchOb.phone + '</div>';
    }
    return markup;
  }

  function formatCustomerSelection (searchOb) {
    return searchOb.text;
  }
 
  function initCustomerSelect2() {
   $(".select2-customers").select2({
    ajax: {
      url: "/searches/customer_search",
      dataType: 'json',
      delay: 250,
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
    templateResult: formatCustomer,
    templateSelection: formatCustomerSelection
   });
   
  }
 });
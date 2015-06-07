$(document).ready(function() {
  
  initUserSelect2();  // intialise select drop downs
  
  function formatUser (searchOb) {
    if (searchOb.loading) return searchOb.text;
    var markup = "";
    if (searchOb.text) {
      markup += '<div>' + searchOb.text + '</div>';
    }
    return markup;
  }

  function formatUserSelection (searchOb) {
    return searchOb.text;
  }
 
  function initUserSelect2() {
   $(".select2-users").select2({
    ajax: {
      url: "/searches/user_search",
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
    templateResult: formatUser,
    templateSelection: formatUserSelection
   });
   
  }
 });

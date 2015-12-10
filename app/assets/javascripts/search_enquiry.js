$(document).ready(function() {
  
  initEnquirySelect2();  // intialise select drop downs
});

function formatEnquiry (searchOb) {
  if (searchOb.loading) return searchOb.text;
  var markup = "";
  if (searchOb.text) {
    markup += '<div>' + searchOb.text + '</div>';
  }
  return markup;
}

function formatEnquirySelection (searchOb) {
  return searchOb.text;
}

function initEnquirySelect2() {
  var current_enquiry = $('#copy_current_enquiry_id').attr('value')
  //ajax version
  $(".select2-enquiries").select2({
    ajax: {
      url: "/searches/enquiry_search",
      dataType: 'json',
      delay: 100,
      data: function (params) {
        return {
          q: params.term, // search term
          current_enquiry: current_enquiry,
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
    width: '100%',
    templateResult: formatEnquiry,
    templateSelection: formatEnquirySelection
  });
  
  // handle items being selected - clear related fields. 
  
  $('.select2-enquiries').on("select2:select", function(e) {

  });  
  
}


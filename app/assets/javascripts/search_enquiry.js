$(document).ready(function() {
  
  initEnquirySelect2();  // intialise select drop downs
});

function initEnquirySelect2() {
  var current_enquiry = $('#copy_enquiry_id').attr('value')
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
    templateResult: formatCountry,
    templateSelection: formatCountrySelection
  });
  
  // handle items being selected - clear related fields. 
  
  $('.select2-enquiries').on("select2:select", function(e) {
    // if countries field changes clear related fields if they exist -  destinations, products....
    // $(this).closest(".row").find(".select2-destinations").val(null).trigger("change");
    // $(this).closest(".row").find(".select2-products").val(null).trigger("change");
    // $(this).closest('.field').find(".cruise-info").hide();
    // $(this).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
    // $(this).closest('.field').find(".select2-room-types-noajax").val(null).trigger("change");
  });  
  
}


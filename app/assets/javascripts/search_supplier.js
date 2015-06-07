$(document).ready(function() {
  
  initSupplierSelect2();  // intialise select drop downs
  
  function formatSupplier (searchOb) {
    if (searchOb.loading) return searchOb.text;
    var markup = "";
    if (searchOb.text) {
      markup += '<div>' + searchOb.text + '</div>';
    }
    return markup;
  }

  function formatSupplierSelection (searchOb) {
    return searchOb.text;
  }
 
  function initSupplierSelect2() {
   $(".select2-suppliers").select2({
    ajax: {
      url: "/searches/supplier_search",
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
    templateResult: formatSupplier,
    templateSelection: formatSupplierSelection
   });
   
  }

  $(".select2-suppliers.supplier-invoice").on("select2-selecting", function(e) {
    $('#supplierDefaultCurrency').val(e.params.data.currency);
    
    if ($('#base_date').length) {  // if we are on the supplier invoice screen and (basedate is present) then update pay date
      if (e.params.data.numdays > 0 ) {
        var dateComp = $('#base_date').val().split('/');
        var changeDate = new Date(dateComp[2],dateComp[1]-1,dateComp[0]);
        changeDate.setDate(changeDate.getDate() - e.params.data.numdays);
        $('#final_payment_due').datepicker('update', changeDate);
      } else {
        var duedateComp = $('#due_date').val().split('/');
        var dueDate = new Date(duedateComp[2],duedateComp[1]-1,duedateComp[0]);
        $('#final_payment_due').datepicker('update', dueDate);
      }
      
    }
  })
});
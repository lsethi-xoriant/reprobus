$(document).ready(function() {
    $("#sup_select").select2({
      placeholder: "Search for supplier",
      allowClear: true,
      //minimumInputLength: 1,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/suppliers/suppliersearch",
        dataType: 'json',
        data: function (term, page) {
            return {
              q: term, // search term
              page_limit: 10
              };
    },
    results: function (data, page) { // parse the results into the format expected by Select2.
            return {results: data.searchSet};}
    },
    initSelection: function(element, callback) {
            var id=$(element).val();
            if (id!=="") {
                $.ajax("/suppliers/"+id+".json", {
                    dataType: "json"
                }).done(function(data) {
                    var selected = {id: element.val(), text: data.name };
                    callback(selected);
                });
            }
        },
    dropdownCssClass: "bigdrop" // apply css that makes the dropdown taller
    });
 });

$(document).ready(function() {
  $("#sup_select").on("select2-selecting", function(e) {
    $('#supplierDefaultCurrency').val(e.choice.currency);
    if (e.choice.numdays > 0 && $('#base_date').length ) {
      var dateComp = $('#base_date').val().split('/');
      var changeDate = new Date(dateComp[2],dateComp[1]-1,dateComp[0]);
      changeDate.setDate(changeDate.getDate() - e.choice.numdays);
      $('#final_payment_due').datepicker('update', changeDate);
    }
  })
});
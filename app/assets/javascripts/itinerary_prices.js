$(document).ready(function() {

  if ($('#supplier_itinerary_price_items').length || $('#itinerary_price_items').length) {
    
    $('#supplier_itinerary_price_items').on('cocoon:after-remove', function() {   // this container is on itinerary new form
  
    });
    
    $('#supplier_itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    
      $(".select2-suppliers-noajax").select2();  
      
    });
    
    
    $('#itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
      $(".select2-suppliers-noajax").select2();  
      
      $(insertedItem).find('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 5, // Creates a dropdown of 15 years to control year
        formatSubmit: 'yyyy-mm-dd',
        format: 'yyyy-mm-dd',
        hiddenSuffix: ''
      });  
      
    });
    
  }
});
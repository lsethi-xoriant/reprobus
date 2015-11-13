$(document).ready(function() {

  if ($('#supplier_itinerary_price_items').length || $('#itinerary_price_items').length) {
    
    $('#supplier_itinerary_price_items').on('cocoon:after-remove', function() {   // this container is on itinerary new form
  
    });
    
    $('#supplier_itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
      $(".select2-suppliers-noajax").select2();  
      
      //$(insertedItem).closest('.field').find(".select2-suppliers-noajax").select2();
      //$(insertedItem).closest('.field').find(".select2-suppliers-noajax").val(null).trigger("change");
      console.log("inserting item ");
    });
    
  }
});
$(document).ready(function() {

  if ($('#supplier_itinerary_price_items').length || $('#itinerary_price_items').length) {
    
    $('#supplier_itinerary_price_items').on('cocoon:after-remove', function() {   // this container is on itinerary new form
  
    });
    
    $('#supplier_itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
    
      $(".select2-suppliers-noajax").select2();  
      reset_material_active_labels('#itinerary_price_items');
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
      
      reset_material_active_labels('#itinerary_price_items');
      
    });
  
      $(document).on('change', '.price_field', function() {
    console.log("pice change");  
      var totalfield = $(this).closest('.field').find('.price_total_field');
      var qtyfield = $(this).closest('.field').find('.qty_field');
      var total = ($(this).val() * qtyfield.val());
    console.log(total);    
      totalfield.val(total);
      
      var depositPercent = $(this).closest('.field').find('.deposit_percent_field').val();
      var depTot = 0;
      depTot = $(".itinerary_price_deposit_system_default").val();
      depTot = (+depTot) + ((depositPercent/100) * total);
      $(".itinerary_price_deposit_system_default").val(depTot);
      
    });
    
    $(document).on('change', '.qty_field', function() {
      //alert( "Handler for .blur() called." );
      var pricefield = $(this).closest('.field').find('.price_field');
      var totalfield = pricefield.closest('.field').find('.price_total_field');
    
      var total = ($(this).val() * pricefield.val());
      totalfield.val(total);
    }); 
      
  }
});


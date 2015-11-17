$(document).ready(function() {

  if ($('#supplier_itinerary_price_items').length || $('#itinerary_price_items').length) {
  // only do if on itinerary price page... 
  
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
  
  
    $(document).on('change', '.price_total_field', function() {
    // CALCULATE ITEM PRICE USING QTY AND TOTAL
    calculateItemPriceFromTotal($(this));
    
    
    });
  
    $(document).on('change', '.price_field', function() {
      calculateTotalFromQtyPrice($(this));
      
      

      var depositPercent = $(this).closest('.field').find('.deposit_percent_field').val();
      var depTot = 0;
      depTot = $(".itinerary_price_deposit_system_default").val();
      depTot = (+depTot) + ((depositPercent/100) * total);
      $(".itinerary_price_deposit_system_default").val(depTot);
      
    });
    
    $(document).on('change', '.qty_field', function() {
      calculateTotalFromQtyPrice($(this));
    }); 
      
  }
});

function calculateTotalFromQtyPrice(e){
  var totalfield = $(e).closest('.field').find('.price_total_field');
  var qtyfield = $(e).closest('.field').find('.qty_field');
  var itemPriceField = $(e).closest('.field').find('.price_field');
  var total = (itemPriceField.val() * qtyfield.val());

  totalfield.val(total.toFixed(2));
}

function calculateItemPriceFromTotal(e){
  var item_price = 0.00;
  var totalfield = $(e).closest('.field').find('.price_total_field');
  var qtyfield = $(e).closest('.field').find('.qty_field');
  var itemPriceField = $(e).closest('.field').find('.price_field');
  // only do this calc if we have a qty value
  if ( isNaN(qtyfield.val()) == false && parseInt(qtyfield.val(),10) > 0)  {
    item_price = (totalfield.val() / qtyfield.val());
  } else {
    item_price = parseFloat(totalfield.val());
  }
  
  itemPriceField.val(item_price.toFixed(2));
}
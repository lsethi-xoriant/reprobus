$(document).ready(function() {
  $('#customer_create_invoice_dummy').on('click', function(e) {
      $(".loading").show();  //show spinner
      e.preventDefault();
      ajaxSaveItineraryPricingForm(createCustomerInvoiceSubmit);
  });
  
  function createCustomerInvoiceSubmit(){
    $(".loading").show();  //show spinner.
    $('#customer_create_invoice')[0].click();
  }    
  
  $('#supplier_create_invoice_dummy').on('click', function(e) {
      $(".loading").show();  //show spinner
      e.preventDefault();
      ajaxSaveItineraryPricingForm(createSupplerInvoiceSubmit);
  });
  
  function createSupplerInvoiceSubmit(){
    $(".loading").show();  //show spinner.
    $('#supplier_create_invoice')[0].click();
  }  
  
  $('#saveCustomerItineraryPriceBtn').on('click', function(e) {
    $(".itinerary_price_form").submit();
  });  
  
  $('#saveSupplierItineraryPriceBtn').on('click', function(e) {
    $(".itinerary_price_form").submit();
  });    
  
  $("#saveItineraryPriceFabBtn").on('click', function(e) {
    $('.itinerary_price_submit_btn').click();
  }); 

  if ($('#itinerary_price_items').length) {
    // only do if on itinerary price page...
    reset_material_active_labels('#itinerary_price_items');
    reset_material_active_labels('#supplier_itinerary_price_items');
    
    // onload calc all deposit totals
    $('.deposit_price_field').each(function() {calculateDepositFromTotalPrice($(this));});
    
    // onload calc all totals.
    doPricingCalculationsCustomerTotals();
    
    // onload calc all markup totals
    $('.markup_percent_field').each(function() {calculateSupplierMarkupFromTotalPrice($(this));});
    
    // colour profit field on load
    colourProfitField();
    
  
    $('#supplier_itinerary_price_items').on('cocoon:after-remove', function() {   // this container is on itinerary new form
  
    });
    
    $('#supplier_itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
      initSupplierSelect2();
      initCurrencySelect2();
      
      reset_material_active_labels('#supplier_itinerary_price_items');
    });
    
    
    $('#itinerary_price_items').on('cocoon:after-insert', function(e, insertedItem) {   // this container is on itinerary new form
      
      $(insertedItem).find('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 5, // Creates a dropdown of 15 years to control year
        formatSubmit: 'yyyy-mm-dd',
        format: 'dd/mm/yyyy',
        hiddenSuffix: '',
        onSet: function (e) {
            if (e.select) {this.close();}
        }
      });
      
      reset_material_active_labels('#itinerary_price_items');
      
      $(insertedItem).closest('.field').find('.qty_field').val($('#itinerary_num_passengers').val());
    });
  
    $(document).on('change', '.grand_total', function() {
      calculateSupplierProfitForPricing();
    });
  
    $(document).on('change', '.deposit_percent_field', function() {
     calculateDepositFromTotalPrice($(this));
     calculateTotalDepositForPricing();
    });
   
    $(document).on('change', '.price_total_field', function() {
    // CALCULATE ITEM PRICE USING QTY AND TOTAL
    calculateItemPriceFromTotal($(this));
    
    calculateTotalForPricing();
    calculateDepositFromTotalPrice($(this));
    calculateTotalDepositForPricing();
    });
    
    $(document).on('change', '.qty_field, .price_field', function() {
      calculateTotalFromQtyPrice($(this));
      
      calculateTotalForPricing();
      calculateDepositFromTotalPrice($(this));
      calculateTotalDepositForPricing();
    });
      
      
    $(document).on('change', '.deposit_system_default', function() {
      // if ticked, only calculate deposit on system %s
      if($('.deposit_system_default').is(":checked")){
        calculateTotalDepositFromSystemDefault();
        //and hide show whatever -
        $(".deposit_percent_field").hide();
        $(".deposit_price_field").hide();
      } else { // go back to normal calculations
        $('.deposit_price_field').each(function() {calculateDepositFromTotalPrice($(this));});
        calculateTotalDepositForPricing();
        calculateTotalForPricing();
        
        //and hide show whatever -
        $(".deposit_percent_field").show();
        $(".deposit_price_field").show();
      }
    });
    
    
    $(document).on('change', '.supplier_qty_field, .supplier_item_price_field', function() {
      calculateSupplierTotalFromQtyPrice($(this));
      calculateExchangeRatePrice($(this));
      calculateSupplierMarkupFromTotalPrice($(this));
      //addSupplierMarkupToTotal($(this));
      calculateSupplierMarkupTotalForPricing();
      calculateSupplierTotalForPricing();
      calculateSupplierSellTotalForPricing();
      calculateSupplierProfitForPricing();
    });
    
    $(document).on('change', '.supplier_sell_total', function() {
      calculateItemPriceFromTotalSupplier($(this));
      calculateExchangeRatePrice($(this));
      calculateSupplierMarkupFromTotalPrice($(this));
      calculateSupplierMarkupTotalForPricing();
      calculateSupplierTotalForPricing();
      calculateSupplierSellTotalForPricing();
      calculateSupplierProfitForPricing();
    });
    
    $(document).on('change', '.markup_percent_field', function() {
      calculateSupplierMarkupFromTotalPrice($(this));
      calculateSupplierMarkupTotalForPricing();
      calculateSupplierProfitForPricing();
    });
  }
});

$(document).on('click', '.supplier-show-hide-btn', function() {
  $(this).closest(".field").find('.suplier_buttons_row').toggle();
});

$(document).on('click', '#email_supplier_quote_OK', function(e) {
  e.preventDefault();
  
  if  (JSON.parse($(this)[0].dataset.confirmed) &&
  CKEDITOR.instances["email_settings_flight_details_" + $(this)[0].dataset.id].getData().trim() == "") {
    Materialize.toast("Flight details can't be empty", 4000);
    return;
  }
  if (JSON.parse($(this)[0].dataset.check) &&
  CKEDITOR.instances["email_settings_check_flight_details_" + $(this)[0].dataset.id].getData().trim() == "") {
    Materialize.toast("Flight details can't be empty", 4000);
    return;
  }  
  
  // else all ok
  formId = $(this).parents('form');
  $('<input />').attr('type', 'hidden')
    .attr('name', "itinerary_price_item_ids")
    .attr('value', $("[name='itinerary_price_item_ids']:checked").map(function() { return this.id; }).get())
    .appendTo(formId);
  $(formId).submit();
  
});

function doPricingCalculationsCustomerTotals(e){
  calculateTotalForPricing();
  calculateTotalDepositForPricing();
}

function calculateTotalFromQtyPrice(e){
  var totalfield = $(e).closest('.field').find('.price_total_field');
  var qtyfield = $(e).closest('.field').find('.qty_field');
  var itemPriceField = $(e).closest('.field').find('.price_field');
  var total = (itemPriceField.val() * qtyfield.val());

  totalfield.val(total.toFixed(2));
}

function calculateExchangeRatePrice(e){
  var totalfield = $(e).closest('.field').find('.supplier_exchange_total');
  var ratefield = $(e).closest('.field').find('.sell_currency_rate');
  var itemPriceField = $(e).closest('.field').find('.supplier_sell_total');
  
  var total = (1 / ratefield.val() ) * itemPriceField.val();

  totalfield.val(total.toFixed(2));
}


function calculateSupplierTotalFromQtyPrice(e){
  var sellfield = $(e).closest('.field').find('.supplier_sell_total');
  var qtyfield = $(e).closest('.field').find('.supplier_qty_field');
  var itemPriceField = $(e).closest('.field').find('.supplier_item_price_field');
  var total = (itemPriceField.val() * qtyfield.val());

  sellfield.val(total.toFixed(2));
}


function calculateSupplierMarkupFromTotalPrice(e){
  var markup_price = 0.00;
  var totalAmount = 0.00;
  var markupAmountField = $(e).closest('.field').find('.markup_price_field');
  
  var markupPercent = $(e).closest('.field').find('.markup_percent_field');
  var totalfield = $(e).closest('.field').find('.supplier_total_inc_markup_field');
  var exchangeTotal = $(e).closest('.field').find('.supplier_exchange_total');

  if ( isNaN(exchangeTotal.val()) ){
    totalAmount = 0.00;
  }else{
    totalAmount = parseFloat(exchangeTotal.val());
  }



  // only do this calc if we have a qty value
  if ( isNaN(markupPercent.val()) === false && parseFloat(markupPercent.val()) > 0)  {
    markup_price = (totalAmount * (markupPercent.val()/100));
  } else {
    markup_price = 0.00;
  }
  markupAmountField.val(markup_price.toFixed(2));
  totalfield.val((totalAmount + markup_price).toFixed(2));
}
/*
function addSupplierMarkupToTotal(e){
  var totalAmount = 0.00;
  var markup_price = 0.00;
  var totalfield = $(e).closest('.field').find('.supplier_total_field');
  var markupAmountField = $(e).closest('.field').find('.markup_price_field');
  
  if ( isNaN(totalfield.val()) ){
    totalAmount = 0.00;
  }else{
    totalAmount = parseFloat(totalfield.val());
  }
  
  if ( isNaN(markupAmountField.val()) ) {
    markup_price = 0.00;
  } else {
    markup_price = parseFloat(markupAmountField.val());
  }
  
  totalAmount = (markup_price + totalAmount);
  totalfield.val(totalAmount.toFixed(2));
}
*/
/*
function calculateSupplierMarkupToTotal(e){
  var totalAmount = 0.00;
  var markup_price = 0.00;
  var totalfield = $(e).closest('.field').find('.supplier_total_field');
  var markupAmountField = $(e).closest('.field').find('.markup_price_field');
  
  if ( isNaN(totalfield.val()) ){
    totalAmount = 0.00;
  }else{
    totalAmount = parseFloat(totalfield.val());
  }
  
  if ( isNaN(markupAmountField.val()) ) {
    markup_price = 0.00;
  } else {
    markup_price = parseFloat(markupAmountField.val());
  }
  
  totalAmount = (markup_price + totalAmount);
  totalfield.val(totalAmount.toFixed(2));
}*/


function calculateItemPriceFromTotal(e){
  var item_price = 0.00;
  var totalfield = $(e).closest('.field').find('.price_total_field');
  var qtyfield = $(e).closest('.field').find('.qty_field');
  var itemPriceField = $(e).closest('.field').find('.price_field');
  // only do this calc if we have a qty value
  if ( isNaN(qtyfield.val()) === false && parseFloat(qtyfield.val()) > 0)  {
    item_price = (totalfield.val() / qtyfield.val());
  } else {
    item_price = parseFloat(totalfield.val());
  }
  
  itemPriceField.val(item_price.toFixed(2));
}

function calculateItemPriceFromTotalSupplier(e){
  var item_price = 0.00;
  var totalfield = $(e).closest('.field').find('.supplier_sell_total');
  var qtyfield = $(e).closest('.field').find('.supplier_qty_field');
  var itemPriceField = $(e).closest('.field').find('.supplier_item_price_field');
  // only do this calc if we have a qty value
  if ( isNaN(qtyfield.val()) === false && parseFloat(qtyfield.val()) > 0)  {
    item_price = (totalfield.val() / qtyfield.val());
  } else {
    item_price = parseFloat(totalfield.val());
  }
  
  itemPriceField.val(item_price.toFixed(2));
}


function calculateTotalForPricing(){
  var sum = 0.00;
  $('.price_total_field').each(function() {
      sum += Number($(this).val());
  });
    
  $(".grand_total").val(sum.toFixed(2));
  $('.grand_total').change();  
}

function calculateSupplierTotalForPricing(){
  var sum = 0.00;
  $('.supplier_sell_total').each(function() {
      sum += Number($(this).val());
  });
    
  $(".grand_supplier_total").val(sum.toFixed(2));
}

function calculateSupplierSellTotalForPricing(){
  var sum = 0.00;
  $('.supplier_exchange_total').each(function() {
      sum += Number($(this).val());
  });
    
  $(".grand_supplier_sell_total").val(sum.toFixed(2));
}

function calculateSupplierProfitForPricing(){
  var totalPriceSupplier = Number($('.grand_supplier_sell_total ').val());
  var totalPriceSell = Number($('.grand_total').val());
    
  $(".grand_profit_total").val((totalPriceSell- totalPriceSupplier).toFixed(2));
  colourProfitField();
}

function calculateSupplierMarkupTotalForPricing(){
  var sum = 0.00;
  $('.supplier_total_inc_markup_field').each(function() {
      sum += Number($(this).val());
  });
    
  $(".grand_incl_markup_total").val(sum.toFixed(2));
}

function colourProfitField(){
  $(".grand_profit_total").removeClass('green-text orange-text red-text');
  
  var profit =  $(".grand_profit_total").val();
  var sellPrice = $('.grand_incl_markup_total').val();
  var profitPercent = profit / sellPrice * 100;
  
  var nicePercentStr = Math.round( profitPercent * 10 ) / 10;  
  var hasAgent = false;
  if ($('#itinerary_price_has_agent').val() != "") { hasAgent = true }
console.log(nicePercentStr);
  
  var good = 15;
  var average = 10;
  
  if (hasAgent) {
    good = 10;
    average = 5;   
  }
  
  if ( profitPercent > good ){
    $(".grand_profit_total").addClass('green-text');
    
  } else if (profitPercent > average ){
    $(".grand_profit_total").addClass('orange-text');
  } else {
    $(".grand_profit_total").addClass('red-text');
  }
  
  //IF AGENT THEN DO DIFFERENT PRICE
}

function calculateTotalDepositForPricing(){
  // if doing system default ignore this calculation!
  if($('.deposit_system_default').is(":checked")){
    calculateTotalDepositFromSystemDefault();
    return;
  }
  
  var sum = 0.00;
  $('.deposit_price_field').each(function() {
      sum += Number($(this).val());
  });
    
  $(".grand_deposit_total").val(sum.toFixed(2));
}

function calculateDepositFromTotalPrice(e){
  // if doing system default ignore this calculation!
  if($('.deposit_system_default').is(":checked")){
    return;
  }
  
  var deposit_price = 0.00;
  var depositAmountField = $(e).closest('.field').find('.deposit_price_field');
  var depositPercent = $(e).closest('.field').find('.deposit_percent_field');
  var totalfield = $(e).closest('.field').find('.price_total_field');

  // only do this calc if we have a qty value
  if ( isNaN(depositPercent.val()) == false && parseFloat(depositPercent.val()) > 0)  {
    deposit_price = (totalfield.val() * (depositPercent.val()/100));
  } else {
    deposit_price = 0;
  }
  
  depositAmountField.val(deposit_price.toFixed(2));
}

function calculateTotalDepositFromSystemDefault(){
  var deposit_price = 0.00;
  var totalSaleAmount = $('.grand_total');
  var systemDefaultPercentage = $('#system_default_for_deposits');
  
  deposit_price = (totalSaleAmount.val() * (systemDefaultPercentage.val()/100));
    
  $(".grand_deposit_total").val(deposit_price.toFixed(2));
}

function ajaxSaveItineraryPricingForm(callBackOnSuccess){
  var valuesToSubmit = $('.itinerary_price_form').serialize();
  $.ajax({
      type: "POST",
      url: $('.itinerary_price_form').attr('action'), //sumbits it to the given url of the form
      data: valuesToSubmit, //,
      error: function(xhr, status, error) {
        $(".loading").hide();
        alert("AJAX Error! Form could not be saved");
      },
      success: function(json){
        $(".loading").hide(); 
        
        if (json.success == true) {
          // do normal submission 
          callBackOnSuccess();
        } else {
          // validation error saving form, so toast a message and quit
          toastr.warning("There are unsaved changes on form that cannot be reconciled - please save form first");    
        }
      }
  });
}





$(document).ready(function() {
  initProductSelect2();  // intialise select drop downs
});
 
function formatProduct (product) {
  if (product.loading) return product.text;
  var markup = "";
  if (product.text) {
    markup += '<div><strong>' + product.type + '</strong></div>';
    //markup += '<div>' + product.name + ' | ' + product.city + ' | ' + product.country + '</div>';
    markup += '<div>' + product.name + '</div>';
  }
  return markup;
}

function formatProductSelection (product) {
  return product.text;
}

function getDestinationSearchTerm(theSelect2Element) {
  var nextProdField = $(theSelect2Element).closest('.row').find(".select2-destinations");
  return $(nextProdField).val();
}

function getCountrySearchTerm(theSelect2Element) {
  //var nextProdField = $(theSelect2Element).closest('.row').find(".select2-countries");
  var nextProdField = $(theSelect2Element).closest('.row').find(".select2-countries-noajax");
  return $(nextProdField).val();
}

function getTypeSearchTerm(theSelect2Element) {
  var nextProdField = $(theSelect2Element).closest('.row').find(".type-itineraries");
  // materialize does funny stuff with select boxes, so return value to get right value
  return $(nextProdField)[1].value;
}

function initProductSelect2() {
  var theSelect2Element = null;
  $(".select2-products").select2({
    ajax: {
      url: "/searches/product_search",
      dataType: 'json',
      delay: 200,
      data: function (params) {
        return {
          q: params.term, // search term
          destination: getDestinationSearchTerm(theSelect2Element),
          country: getCountrySearchTerm(theSelect2Element),
          type: getTypeSearchTerm(theSelect2Element),
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
    minimumInputLength: 1,
    templateResult: formatProduct,
    templateSelection: formatProductSelection

  }).on('select2:open', function(e){ 
   theSelect2Element = e.currentTarget;});

   
  /* on selection of product set other fields in row - i.e the itinerary templage form */
  var $eventSelect = $(".select2-products");
  $eventSelect.on("select2:select", function (e) {
    // data is returned data for selection 
    var data = e.params.data;
//console.log(data);    
    // get all the elements we will need to manipulate. 
    var productId = $(this).val();
    var nextTypeField = $(this).closest('.row').find(".type-itineraries");
    var nextProductContainer = $(this).closest('.field').find(".product_details_cont");
    var nextProdDetailsField = $(this).closest('.field').find(".product_details");
    var nextCruiseContainer = $(this).closest('.field').find(".cruise-info");
    var nextDestField = $(this).closest(".row").find(".select2-destinations");
    var nextCountField = $(this).closest(".row").find(".select2-countries-noajax");
    var nextNumDaysField = $(this).closest(".row").find(".itinerary-number-days");
    var nextSuppField = $(this).closest(".field").find(".select2-suppliers-noajax");
    var nextRoomTypeField =  $(this).closest('.field').find(".select2-room-types-noajax");
    
    // update associated fields for a product selection 
    if (nextTypeField.find("option:selected").text() != data.type){
      nextTypeField.material_select('destroy'); 
      nextTypeField.val(data.type).material_select();
    }
    if (nextCountField.find("option:selected").val() != data.country_id){
      nextCountField.val(data.country_id).trigger("change");
    }
    if (nextDestField.find("option:selected").val() != data.destination_id){
      nextDestField.empty().append('<option value="'+data.destination_id+'">'+data.city+'</option>').val(data.destination_id).trigger("change");
    }
    
    if (nextNumDaysField.val() != data.numdays) {nextNumDaysField.val(data.numdays);}

    // do ajax call to get supplier and room type info to populate dropdowns. 
    $.ajax({
        url: "/searches/product_info_search",
        //dataType: 'json',
        data: {
              product: productId
              }
      }).done(function(data) {
console.log(data);
        // populate supplier dropdown, and room type dropdown
        var optionStr = "";
        var selectedVal;
        $.each(data.suppliers,function(i, item){
          optionStr = optionStr + '<option value="'+item.id+'">'+item.supplier_name+'</option>';
        });
        if (data.suppliers.length == 1){selectedVal = data.suppliers[0].id;}
        nextSuppField.empty().append(optionStr).val(selectedVal).trigger("change");
        
        optionStr = "";
        selectedVal = 0;
        $.each(data.roomtypes,function(i, item){
          optionStr = optionStr + '<option value="'+item.id+'">'+item.room_type+'</option>';
        });    
        if (data.roomtypes.length == 1){selectedVal = data.roomtypes[0].id;}
        nextRoomTypeField.empty().append(optionStr).val(selectedVal).trigger("change");
        
        if (data.type == "Cruise" || data.type == "Hotel") {
          $(nextRoomTypeField).closest('.field').find(".room_type_cont").show();
        } else {
          $(nextRoomTypeField).closest('.field').find(".room_type_cont").hide();
        }  
      });

    // handle specialy, need to add all cruise legs... do ajax search and get cruise legs. 
    //if (nextTypeField.find("option:selected").text() == "Cruise") {
    if (e.params.data.type == "Cruise") {
      $.ajax({
        url: "/searches/cruise_info_search",
        //dataType: 'json',
        data: {
              product: productId
              }
      }).done(function(data) {
        nextCruiseContainer.html(data);
        nextCruiseContainer.show();
        nextProductContainer.hide();
        $('.modal-trigger').leanModal(); // cruise info put into a modal. it will need initialising
      });
    } else {
      // display any additional details in product details field. 
      nextProdDetailsField.val(e.params.data.type + " | "  + e.params.data.name + " | "  + e.params.data.city + " | "  + e.params.data.country);
      nextProdDetailsField.next().addClass('active'); // set label to be active.
      nextCruiseContainer.hide();
      nextProductContainer.show();
    }
    
    //now populate the supplier field.
    
    
  });  
}
